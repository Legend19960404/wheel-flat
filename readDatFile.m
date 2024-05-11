function result=readDatFile(path)
result=[];
file_ID=fopen(path,'r');
idx=0;
start_num=17;%从第17行开始读取
while ~feof(file_ID)
    idx=idx+1;
    line=fgetl(file_ID);
    if(idx>=start_num)
        line=strrep(line,',','.');
        str_arr=strsplit(line,'\t');
        x=str2double(str_arr(1));
        y=str2double(str_arr(2));
        result=[result;[x,y]];
    end
end
fclose(file_ID);
end
