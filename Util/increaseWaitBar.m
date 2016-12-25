function increaseWaitBar(h,p,val)
if p.GUI 
    waitbar(val,h)
end
if val ==1
    close(h);
end
end