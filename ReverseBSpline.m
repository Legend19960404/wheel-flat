%X,Y为曲线上的数据点,k为样条曲线的阶次
function [dx,dy]=ReverseBSpline(k,X,Y)
m=length(X)-1;
n=m+k-1;
L=zeros(1,m);
data_section=zeros(2,length(X));
dx=zeros(1,length(X)+2);
dy=zeros(1,length(X)+2);
for i=1:length(X)
    data_section(:,i)=[X(i),Y(i)]';   
end
for i=1:m
    L(i)=sqrt((data_section(1,i+1)-data_section(1,i))^2+(data_section(2,i+1)-data_section(2,i))^2);
end
L_sum=sum(L);
U=zeros(1,n+k+1+1);
U(1,1:k+1)=0;
U(1,n+2:n+k+1+1)=1;
for i=1:m
    U(k+1+i)=sum(L(1:i))/L_sum;    
end
delta=U(2:end)-U(1:end-1);%构造前向差分序列
delta=[delta,0];%最后的delta_i=0
a=zeros(1,n-1);
b=zeros(1,n-1);
c=zeros(1,n-1);
e=zeros(2,n-1);
for i=2:n-2
    a(i)=delta(i+3)^2/(delta(i+1)+delta(i+2)+delta(i+3));
    b(i)=delta(i+3)*(delta(i+1)+delta(i+2))/(delta(i+1)+delta(i+2)+...
         delta(i+3))+delta(i+2)*(delta(i+3)+delta(i+4))/(delta(i+2)+...
         delta(i+3)+delta(i+4));
    c(i)=delta(i+2)^2/(delta(i+2)+delta(i+3)+delta(i+4));
    e(:,i)=(delta(i+2)+delta(i+3)).*data_section(:,i);
end
%自由端点边界条件
b(1)=delta(2)+2*delta(3)+2*delta(4)+delta(5);
c(1)=-(delta(2)+delta(3)+delta(4));
a(1)=0;
e(:,1)=(delta(3)+delta(4)+delta(5)).*data_section(:,1);
c(n-1)=0;
a(n-1)=-(delta(n+1)+delta(n+2)+delta(n+3));
b(n-1)=delta(n)+2*delta(n+1)+2*delta(n+2)+delta(n+3);
e(:,n-1)=(delta(n)+delta(n+1)+delta(n+2)).*data_section(:,n-1);
%系数矩阵
coefficient=zeros(n-1,n-1);
coefficient(1,1:3)=[b(1),c(1),a(1)];
coefficient(n-1,n-3:n-1)=[c(n-1),a(n-1),b(n-1)];
for i=2:n-2
    coefficient(i,i-1:i+1)=[a(i),b(i),c(i)];
end
d=(coefficient\e')';
d=[data_section(:,1) d data_section(:,end)];
for i=1:length(d(:,1:end))
    dx(i)=d(1,i);
    dy(i)=d(2,i);
end
end
