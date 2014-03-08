clear all;close all; clc;

P=generate_Pcpp();
icr=generate_ICRcpp();


comb=allcomb(icr.ind);
nc=size(comb,1);

inv_G=[];
count=0;
Qr=0;
for i=1:nc    
    
    W=[P(comb(i,:)).w]';
    try
        [o s]=force_closure_test_QR(W);
    catch
        message='Caught Qhull-exception, skipping...';
        disp(message);
        continue;        
    end

    if (min(s.b)<Qr) | (o~=1)
        message=strcat('Grasp:',{' '},num2str(i),{' '},'is invalid');
        disp(message);
        inv_G=[inv_G;comb(i,:)];
    end
    count=count+1;
    
    if ~mod(count,100)
        message=strcat('Remaining iterations:',{' '},num2str(nc-count));
        disp(message);
    end
    save('inv_G','inv_G');
end
message=strcat(num2str(size(inv_G,1)),{' '},'invalid grasps found');
disp(message);


