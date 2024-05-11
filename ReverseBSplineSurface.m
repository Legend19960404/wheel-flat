%X,Y,Z每行是一个截面,每列是截面上的数据点,k,l为u,v方向的阶次
function [dx,dy,dz]=ReverseBSplineSurface(k,l,X,Y,Z)
[row,col]=size(X);
%构造整个型面的U向节点序列，所有截面平均规范积累弦长参数化
u_m=col-1;
u_n=u_m+k-1;
final_U=zeros(1,u_n+k+1+1);
data_center=zeros(3,row);%截面数据点重心
for row_i=1:row
    %获取每一截面的数据点    
    section_data=zeros(3,col);
    for col_j=1:col
        section_data(:,col_j)=[X(row_i,col_j) Y(row_i,col_j) Z(row_i,col_j)]';     
    end
    %构造每一截面的节点序列
    L=zeros(1,u_m);
    for temp_i=1:u_m
        L(temp_i)=sqrt((section_data(1,temp_i+1)-section_data(1,temp_i))^2+(section_data(2,temp_i+1)-section_data(2,temp_i))^2+(section_data(3,temp_i+1)-section_data(3,temp_i))^2);      
    end
    L_sum=sum(L);
    U=zeros(1,u_n+k+1+1);
    U(1,1:k+1)=0;
    U(1,u_n+2:u_n+k+1+1)=1;
    for temp_i=1:u_m
        U(k+1+temp_i)=sum(L(1:temp_i))/L_sum;
    end
    final_U=final_U+U; 
    center_x=sum(section_data(1,:))/col;
    center_y=sum(section_data(2,:))/col;
    center_z=sum(section_data(3,:))/col;
    data_center(:,row_i)=[center_x center_y center_z]';   
end
final_U=final_U/row;


%构造整个型面的V向节点序列，数据点重心积累弦长规范化
[~,data_center_col]=size(data_center);
v_m=data_center_col-1;
v_n=v_m+l-1;
L_center=zeros(1,v_m);
for temp_i=1:v_m
    L_center(temp_i)=sqrt((data_center(1,temp_i+1)-data_center(1,temp_i))^2+(data_center(2,temp_i+1)-data_center(2,temp_i))^2+(data_center(3,temp_i+1)-data_center(3,temp_i))^2);
end
L_center_sum=sum(L_center);
final_V=zeros(1,v_n+l+1+1);
final_V(1:l+1)=0;
final_V(1,v_n+1:v_n+l+1+1)=1;
for temp_i=1:v_m
    final_V(l+1+temp_i)=sum(L_center(1:temp_i))/L_center_sum;
end
%初始化最终的控制点网格矩阵
dx=zeros(row+2,col+2);
dy=zeros(row+2,col+2);
dz=zeros(row+2,col+2);

middle_dx=zeros(row,col+2);
middle_dy=zeros(row,col+2);
middle_dz=zeros(row,col+2);


%计算U方向的各截面控制点，得到中间顶点
delta_U=final_U(2:end)-final_U(1:end-1);
delta_U=[delta_U,0];
%遍历截面，向U节点序列插值
for u_temp_i=1:row
    section_data=zeros(3,col);
    for col_j=1:col
        section_data(:,col_j)=[X(u_temp_i,col_j) Y(u_temp_i,col_j) Z(u_temp_i,col_j)]';     
    end
    u_a=zeros(1,u_n-1);
    u_b=zeros(1,u_n-1);
    u_c=zeros(1,u_n-1);
    u_e=zeros(3,u_n-1);
    for temp_i=2:u_n-2
        u_a(temp_i)=delta_U(temp_i+3)^2/(delta_U(temp_i+1)+delta_U(temp_i+2)+delta_U(temp_i+3));
        u_b(temp_i)=delta_U(temp_i+3)*(delta_U(temp_i+1)+delta_U(temp_i+2))/(delta_U(temp_i+1)+delta_U(temp_i+2)+...
        delta_U(temp_i+3))+delta_U(temp_i+2)*(delta_U(temp_i+3)+delta_U(temp_i+4))/(delta_U(temp_i+2)+...
        delta_U(temp_i+3)+delta_U(temp_i+4));
        u_c(temp_i)=delta_U(temp_i+2)^2/(delta_U(temp_i+2)+delta_U(temp_i+3)+delta_U(temp_i+4));
        u_e(:,temp_i)=(delta_U(temp_i+2)+delta_U(temp_i+3)).*section_data(:,temp_i);  
    end
    %自由端点边界条件
    u_b(1)=delta_U(2)+2*delta_U(3)+2*delta_U(4)+delta_U(5);
    u_c(1)=-(delta_U(2)+delta_U(3)+delta_U(4));
    u_a(1)=0;
    u_e(:,1)=(delta_U(3)+delta_U(4)+delta_U(5)).*section_data(:,1);
    u_c(u_n-1)=0;
    u_a(u_n-1)=-(delta_U(u_n+1)+delta_U(u_n+2)+delta_U(u_n+3));
    u_b(u_n-1)=delta_U(u_n)+2*delta_U(u_n+1)+2*delta_U(u_n+2)+delta_U(u_n+3);
    u_e(:,u_n-1)=(delta_U(u_n)+delta_U(u_n+1)+delta_U(u_n+2)).*section_data(:,u_n-1);
    
    u_coefficient=zeros(u_n-1,u_n-1);
    u_coefficient(1,1:3)=[u_b(1),u_c(1),u_a(1)];
    u_coefficient(u_n-1,u_n-3:u_n-1)=[u_c(u_n-1),u_a(u_n-1),u_b(u_n-1)];    
    for temp_i=2:u_n-2
        u_coefficient(temp_i,temp_i-1:temp_i+1)=[u_a(temp_i),u_b(temp_i),u_c(temp_i)];
    end
    
    d=(u_coefficient\u_e')';
    u_d=[section_data(:,1) d section_data(:,end)];
    for temp_i=1:length(u_d(:,1:end))
        middle_dx(u_temp_i,temp_i)=u_d(1,temp_i);
        middle_dy(u_temp_i,temp_i)=u_d(2,temp_i);
        middle_dz(u_temp_i,temp_i)=u_d(3,temp_i);
    end 
end
%以中间顶点为数据点，计算最终曲面控制点

delta_V=final_V(2:end)-final_V(1:end-1);
delta_V=[delta_V 0];


[middle_row,middle_col]=size(middle_dx);
for v_i=1:middle_col
    vertical_section_data=zeros(3,middle_row);
    for v_temp_i=1:middle_row
        vertical_section_data(:,v_temp_i)=[middle_dx(v_temp_i,v_i) middle_dy(v_temp_i,v_i) middle_dz(v_temp_i,v_i)]';
    end
    v_a=zeros(1,v_n-1);
    v_b=zeros(1,v_n-1);
    v_c=zeros(1,v_n-1);
    v_e=zeros(3,v_n-1);
    for temp_i=2:v_n-2
        v_a(temp_i)=delta_V(temp_i+3)^2/(delta_V(temp_i+1)+delta_V(temp_i+2)+delta_V(temp_i+3));
        v_b(temp_i)=delta_V(temp_i+3)*(delta_V(temp_i+1)+delta_V(temp_i+2))/(delta_V(temp_i+1)+delta_V(temp_i+2)+...
        delta_V(temp_i+3))+delta_V(temp_i+2)*(delta_V(temp_i+3)+delta_V(temp_i+4))/(delta_V(temp_i+2)+...
        delta_V(temp_i+3)+delta_V(temp_i+4));
        v_c(temp_i)=delta_V(temp_i+2)^2/(delta_V(temp_i+2)+delta_V(temp_i+3)+delta_V(temp_i+4));
        v_e(:,temp_i)=(delta_V(temp_i+2)+delta_V(temp_i+3)).*vertical_section_data(:,temp_i);  
    end
    %自由端点边界条件
    v_b(1)=delta_V(2)+2*delta_V(3)+2*delta_V(4)+delta_V(5);
    v_c(1)=-(delta_V(2)+delta_V(3)+delta_V(4));
    v_a(1)=0;
    v_e(:,1)=(delta_V(3)+delta_V(4)+delta_V(5)).*vertical_section_data(:,1);
    v_c(v_n-1)=0;
    v_a(v_n-1)=-(delta_V(v_n+1)+delta_V(v_n+2)+delta_V(v_n+3));
    v_b(v_n-1)=delta_V(v_n)+2*delta_V(v_n+1)+2*delta_V(v_n+2)+delta_V(v_n+3);
    v_e(:,v_n-1)=(delta_V(v_n)+delta_V(v_n+1)+delta_V(v_n+2)).*vertical_section_data(:,v_n-1);
    
    v_coefficient=zeros(v_n-1,v_n-1);
    v_coefficient(1,1:3)=[v_b(1),v_c(1),v_a(1)];
    v_coefficient(v_n-1,v_n-3:v_n-1)=[v_c(v_n-1),v_a(v_n-1),v_b(v_n-1)];
    for temp_i=2:v_n-2
        v_coefficient(temp_i,temp_i-1:temp_i+1)=[v_a(temp_i),v_b(temp_i),v_c(temp_i)];
    end
    d=(v_coefficient\v_e')';
    v_d=[vertical_section_data(:,1) d vertical_section_data(:,end)];
    for temp_i=1:length(v_d(:,1:end))
        dx(temp_i,v_i)=v_d(1,temp_i);
        dy(temp_i,v_i)=v_d(2,temp_i);
        dz(temp_i,v_i)=v_d(3,temp_i);
    end   
end
end