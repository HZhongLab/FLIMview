function str = h_copy(vector,direction)

if ~(exist('direction')==1)|isempty(direction)
    direction = 'vertical';
end

siz = size(vector);

if length(siz)>2
% elseif ~isempty(find(siz==1))
%     if strcmp(lower(direction),'horizontal')
%         spacing_char = char(9);
%     else
%         spacing_char = char(10);
%     end
%     
%     str = '';
%     for i = 1:length(vector)
%         str = [str,num2str(vector(i)),spacing_char];
%     end
else
    str = '';
    if strcmp(lower(direction),'horizontal')
        for i = 1:siz(1)
            if iscellstr(vector)
                str = [str,vector{i,1}];
            else
                str = [str,num2str(vector(i,1))];
            end
            for j = 2:siz(2)
                if iscellstr(vector)
                    str = [str,vector{i,j}];
                else
                    str = [str,char(9),num2str(vector(i,j))];
                end
            end
            str = [str,char(10)];
        end
    else
        for i = 1:siz(2)
            if iscellstr(vector)
                str = [str,vector{1,i}];
            else
                str = [str,num2str(vector(1,i))];
            end
            for j = 2:siz(1)
                if iscellstr(vector)
                    str = [str,vector{j,i}];
                else
                    str = [str,char(9),num2str(vector(j,i))];
                end
            end
            str = [str,char(10)];
        end
    end
end

clipboard('copy',str);