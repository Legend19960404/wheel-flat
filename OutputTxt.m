function OutputTxt(X,Y,Z)
[row,~]=size(X);
file_num=row;
for i=1:file_num
    file_name=sprintf('section-%s.txt',num2str(i));
    data=[X(i,:)',Y(i,:)',Z(i,:)'];
    fid=fopen(file_name,'wt');
    [M,N]=size(data);
    for row_tmp=1:M
        for col_tmp=1:N
            if col_tmp==N
                fprintf(fid,'%g\n',data(row_tmp,col_tmp));
            else
                fprintf(fid,'%g\t',data(row_tmp,col_tmp));
            end
        end
    end
    fclose(fid);
    ddd=load(file_name);
    x=ddd(:,1);
    y=ddd(:,2);
    z=ddd(:,3);
    plot3(x,y,z);
    hold on;
end
end