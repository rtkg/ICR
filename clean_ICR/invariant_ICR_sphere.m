function [icr, nb_points] = invariant_ICR_sphere(G, P ,alpha, LP_flag, plot_flag)
%
% generates ICRs for a grasp G
%
% origin_offset = [x; y; z; rpy_angles]
%
% ---------------------------------------------------------------------
% NOTE: in form_ICR_sphere we could possibly add the same points to different ICRs !!
% ---------------------------------------------------------------------

nP = length(P);
N = length(G);
L = size(P(1).w,2);

W = [P(G).w]';
[origin_in_ch,str] = force_closure_test_QR(W);
Qs = min(str.b);
Qr = alpha*Qs;

A = str.A;
nA = size(A,1);

if Qs < 0
    disp('Not FC grasp (stop ICR growing)')
    icr = [];
    nb_points = 0;
    return
end


% ------------------------------------------------
% LP related
% ------------------------------------------------
if LP_flag
    vartype=repmat('C',L+1,1);
    param.msglev=1;
    f_obj = [1;zeros(L,1)];
    lb = zeros(L+1,1);
    ub = repmat(100000,L+1,1); % inf
    b = zeros(nA,1)-Qr; % + numerical tolerance
    De = [0, ones(1,L)];
end
% ------------------------------------------------

[rho_nl{1:N}] = deal({});
HH = zeros(N,L);
for n = 1:N
    j = 1;
    for i = (n-1)*L+1:n*L
        [rho_nl{n}{j},dummy] = find(str.Ka == i);
        HH(n,j) = length(rho_nl{n}{j});
        j = j+1;
    end
end

icr(N).ind = [];
icr(N).N = [];
icr(N).current = [];
icr(N).e = [];


for n = 1:N
    icr(n).ind = zeros(1,nP);
    icr(n).ind(1) = G(n); % we dont check point G(n) for inclusion in ICRn (it belongs to it by construction)
    
    icr(n).e = zeros(1,nP);
    icr(n).e(G(n)) = 1; % set as explored
    
    icr(n).N = 1;
    icr(n).current = 1;
    
    while icr(n).ind(icr(n).current) ~= 0
        for s = P(icr(n).ind(icr(n).current)).nb_i
            %for s = 1:nP
            if ~icr(n).e(s)
                
                % a point is labeled as "explored" even if it is not added to
                % an ICR (so that we dont explore it as someone else's neighbor)
                % that's how we can reduce the number of times a point is checked
                icr(n).e(s) = 1;
                
                H = HH(n,:);
                exit_flag = 0;
                lv = 1;
                % check for inclusion in Snl of neighboring point s
                while ~exit_flag && lv <= L
                    if H(lv) ~= 0
                        if LP_flag
                            % -------------------------------
                            % option 1:  solve an LP
                            % -------------------------------
                            D = [-ones(H(lv),1), A(rho_nl{n}{lv},:)*P(s).w; De];
                                                                               
                            ctype=repmat('U',H(lv)+1,1);
                            ctype(H(lv)+1) = 'S'; % equality constraint
                            [x_feasib, fmin,status,extra] = glpk(f_obj,D,[b(1:H(lv));1],lb,ub,ctype,vartype,1,param);
                                                            
                            if x_feasib(1) > 1e-15
                                exit_flag = 1;
                            end
                            % -------------------------------
                        else
                            % -------------------------------
                            %option 2:  evaluate sign of linear equation
                            % -------------------------------
                            l = 1;
                            exit_flag_sign_check = 0;
                            exit_flag = 1;
                            while ~exit_flag_sign_check && l <= L
                          
                                hp_side = A(rho_nl{n}{lv},:)*P(s).w(:,l) + Qr;
                                if max(hp_side) <= 0
                                    exit_flag_sign_check = 1;
                                    exit_flag = 0;
                                end
                                l=l+1;
                            end
                            % -------------------------------
                        end
                    end
                    lv=lv+1;
                end
                % add point s to ICRn (and to the open list of points)
                if lv == L+1 && exit_flag ~= 1
                    icr(n).N = icr(n).N+1;
                    icr(n).ind(icr(n).N) = s;
                end
            end
        end
        icr(n).current = icr(n).current+1;
    end
end

for n=1:N
    icr(n).ind = icr(n).ind(1:icr(n).N);
end

nb_points = sum([icr(:).N]);

% ----------------------------------------------------------------------
% plot related
% ----------------------------------------------------------------------
if plot_flag
    hold on;
    ICR = [icr(:).ind];
    for i=1:nb_points
        %plot3(P(ICR(i)).p(1),P(ICR(i)).p(2),P(ICR(i)).p(3),'bs','MarkerSize',10);
        plot3(P(ICR(i)).p(1),P(ICR(i)).p(2),P(ICR(i)).p(3),'bs','MarkerSize',7,'MarkerFaceColor','k');
    end
    
    % plot inital grasp
    temp=[P(G).p];
    plot3(temp(1,:),temp(2,:),temp(3,:),'rs','MarkerSize',10);
    
    plot_cone(P,G);
    
    pts = [P(:).p];
    %trisurf(P(1).tri,pts(1,:),pts(2,:),pts(3,:),2,'FaceAlpha',0.2,'LineStyle','none');
    trisurf(P(1).tri,pts(1,:),pts(2,:),pts(3,:),2,'FaceAlpha',0.4);
    xlabel('x');
    ylabel('y');
    zlabel('z');
    grid on
    axis equal
    
    fprintf('\n number of points = %i \n',nb_points);
end

%%%EOF

