clc;
close all;
clear all;
sheetName='0.6';
width=40;
path='D:\百度云同步空间\BaiduSyncdisk\data\sections.xlsx';
T1=xlsread(path,sheetName);
%重采样构造方阵,利用B样条插值
data_num=40;
[~,col]=size(T1);
sample_matrix=zeros(data_num,col);
section_num=col/2;
interval=width/(section_num-1);
for i=1:section_num
    if(i==1||i==section_num)
        sample_matrix(:,i*2-1)=ones(data_num,1);
        sample_matrix(:,i*2)=zeros(data_num,1);
    else
        x=T1(:,i*2-1);
        y=T1(:,i*2);
        x=x(~isnan(x));
        y=y(~isnan(y));
        x_arr=linspace(x(1),x(end),data_num)';
        y_arr=spline(x,y,x_arr);
        sample_matrix(:,i*2-1)=x_arr;
        sample_matrix(:,i*2)=y_arr;
    end
end
roughness_x=zeros(data_num,section_num);
roughness_y=zeros(data_num,section_num);
roughness_z=zeros(data_num,section_num);
for i=1:section_num
    x=sample_matrix(:,i*2-1);
    y=sample_matrix(:,i*2);
    length_x=x(end)-x(1);
    for j=1:data_num
        roughness_x(j,i)=-length_x/2+x(j)-x(1);
        roughness_y(j,i)=-width/2+interval*(i-1);
        roughness_z(j,i)=y(j)/1000;
    end
end
[dx,dy,dz]=ReverseBSplineSurface(3,3,roughness_x,roughness_y,roughness_z);
plotMesh(dx,dy,dz);
[M,N]=size(roughness_x);
[px,py,pz]=ForwardCalculateSurface(3,3,4,4,M*10,N*10,dx,dy,dz);
% surf(px,py,pz);
% axis off;
res=[];
[col,row]=size(px);
for i=1:col
    for j=1:row
        tmp=[px(i,j),py(i,j),pz(i,j)];
        res=[res;tmp];
    end
end
disp(res);




















