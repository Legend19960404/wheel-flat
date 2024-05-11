clc;
close all;
for i=1:10
    fileName=sprintf('0.6-%s.xlsx',num2str(i));
    T=xlsread(fileName);
    cir=T(:,1);
    angle=T(:,1)/cir(end)*2*pi;
    roughness=T(:,2);
    figure;
    polarplot(angle,roughness,'-k','LineWidth',2);
    rlim([-600 300]);
end
