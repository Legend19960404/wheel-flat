clc;
clear all;
T=xlsread('section.xlsx');
test_section_num=11;
test_flat_width=40;
interval=test_flat_width/(test_section_num-1);
[row,col]=size(T);
section_num=col/2;
data_num=row;
roughness_x=zeros(data_num,section_num);
roughness_y=zeros(data_num,section_num);
roughness_z=zeros(data_num,section_num);
for i=1:section_num
    section_length_arr=T(:,i*2-1);
    data_arr=T(:,i*2);
    section_length=section_length_arr(end)-section_length_arr(1);
    for j=1:data_num
        roughness_x(j,i)=-section_length/2+section_length_arr(j)-section_length_arr(1);
        roughness_y(j,i)=-test_flat_width/2+interval*(i-1);
        roughness_z(j,i)=data_arr(j)/1000;
    end 
end
[dx,dy,dz]=ReverseBSplineSurface(3,3,roughness_x,roughness_y,roughness_z);
plotMesh(dx,dy,dz);
[M,N]=size(roughness_x);
[px,py,pz]=ForwardCalculateSurface(3,3,4,4,M*10,N*10,dx,dy,dz);
surf(px,py,pz);
xlim([-40 40]);
ylim([-40 40]);
xlabel('x/mm');
ylabel('y/mm');
zlabel('z/mm');
view(-30,50);






