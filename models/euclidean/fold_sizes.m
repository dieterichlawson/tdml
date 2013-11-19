function sizes = fold_sizes(size,fold_size)
    num_folds = round(size/fold_size);
    sizes = ones(num_folds,1)*fold_size;
    rem = sum(sizes) - size;
    if sum(sizes) > size
        for i=1:rem; sizes(i) = sizes(i)-1; end;
    elseif sum(sizes) < size
        for i=1:abs(rem); sizes(i) = sizes(i)+1; end;
    end
end

