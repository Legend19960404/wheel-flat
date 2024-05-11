function [px,py]=ForwardCalculate(k,X,Y,piece_u,mode)
n=length(X)-1;
Nik_u=zeros(n+1, 1);
switch mode
    case 1
        NodeVector_u=linspace(0, 1, n+k+2);
        u=linespace(k/(n+k+1),(n+1)/(n+k+1),piece_u);
        px=zeros(1,piece_u);
        py=zeros(1,piece_u);
        for j=1:piece_u
            for ii=0:1:n
                Nik_u(ii+1, 1) = BaseFunction(ii, k , u(j), NodeVector_u);
            end
            px(j)=X(1,:)*Nik_u;
            py(j)=Y(1,:)*Nik_u;
        end   
    case 2
        NodeVector_u = U_quasi_uniform(n, k); % 准均匀B样条的u向节点矢量
        u = linspace(0, 1-0.0001, piece_u);    %% u向节点分成若干份
        px=zeros(1,piece_u);
        py=zeros(1,piece_u);
        for j=1:piece_u
            for ii=0:1:n
                Nik_u(ii+1, 1) = BaseFunction(ii, k , u(j), NodeVector_u);
            end
            px(j)=X(1,:)*Nik_u;
            py(j)=Y(1,:)*Nik_u;
        end    
    case 3
        if ~mod(n,k)
            NodeVector_u = U_quasi_uniform(n, k); % 准均匀B样条的u向节点矢量
            u = linspace(0, 1-0.0001, piece_u);    %% u向节点分成若干份
            px=zeros(1,piece_u);
            py=zeros(1,piece_u);
            for j=1:piexe_u
                for ii=0:1:n
                    Nik_u(ii+1, 1) = BaseFunction(ii, k , u(j), NodeVector_u);
                end
                px(j)=X(1,:)*Nik_u;
                py(j)=Y(1,:)*Nik_u;
            end  
        else
            errordlg('Error: n/k is not an integer!', 'Piecewise Bezier');
        end      
    otherwise
        u = linspace(0, 1-0.0001, piece_u);    %% u向节点分成若干份
        px=zeros(1,piece_u);
        py=zeros(1,piece_u);
        Points = zeros(2, n+1);
        Points(1, :) = X(1, :);
        Points(2, :) = Y(1, :);
        NodeVector_u = zeros(1, n+k+2);       % 节点矢量长度为n+k+2
        NodeVector_u(1, n+2 : n+k+2) = ones(1, k+1);  % 右端节点置1
        Len = zeros(1, n);    % 控制多边形共n条边
        for iP = 2 : n+1
            Len(iP-1) = sqrt((Points(1,iP) - Points(1,iP-1))^2+(Points(2,iP) - Points(2,iP-1))^2);               
        end
        Lsum = 2*sum(Len) - Len(1) - Len(n);
        for iP = k+2 : n+1
            NodeVector_u(1, iP) = (2*sum( Len(1 : iP-2) ) - Len(1) - Len(iP-2)) / Lsum;       
        end
        for j=1:piece_u
            for ii=0:1:n
                Nik_u(ii+1, 1) = BaseFunction(ii, k , u(j), NodeVector_u);
            end
            px(j)=X(1,:)*Nik_u;
            py(j)=Y(1,:)*Nik_u;
        end 
end
end