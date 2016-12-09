function num = num2string(num)
num = num2str(num);
I = num=='.';
num(I)='_';
end