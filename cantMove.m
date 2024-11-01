function crash = cantMove(seg,S,D)

dir = seg(:,2)-seg(:,1);
dir = dir/norm(dir);
crash = changedir([S D],seg(1,1),seg(2,1),dir,+inf) ||...
    changedir([S D],seg(1,2),seg(2,2),-dir,+inf);

end