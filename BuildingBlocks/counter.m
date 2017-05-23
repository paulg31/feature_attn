function counter()
type = [1 2 3 4 5];
new_type = type(2:5);
keep_going = 1;
num_reps = 2;
type = [1];

while keep_going == 1
    for n = 1:num_reps
        perm = new_type(randperm(numel(new_type)));
        type = [type perm]
    end
    
    if type(5) == type(6)
        keep_going = 1;
        type = [1];
    else
        keep_going = 0;
    end
end
    
typefinal = type
find(5,typefinal)
end

