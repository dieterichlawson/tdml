           % find the template, i.e. the vector with the smallest mean
            % distance to other vectors
            
%             
%             minmean = [Inf('double') -1];
%             min = 0; max = 0; mean = 0;
%             for i=1:size(Attmps,1)
%                 vmin = Inf('double');
%                 vmax = -Inf('double');
%                 vmean = 0;
%                 for j=1:size(Attmps,1)
%                     if i == j; continue; end
%                     dist = norm(Attmps(i,:) - Attmps(j,:),normNum);
%                     vmean = vmean + dist;
%                     if dist > vmax ; vmax = dist; end
%                     if dist < vmin ; vmin = dist; end
%                 end
%                 vmean = vmean / (size(Attmps,1)-1);
%                 if(vmean < minmean(1)) minmean = [vmean i]; end
%                 min = min + vmin;
%                 max = max + vmax;
%                 mean = mean + vmean;
%             end
%             min = min / size(Attmps,1);
%             max = max / size(Attmps,1);
%             mean = mean / size(Attmps,1);
%             closest = minmean(2);
%             temp = 0;
%             for i=1:size(Attmps,1)
%                 if i == closest; continue; end
%                 temp = temp + norm(Attmps(closest,:) - Attmps(i,:),normNum);
%             end
%             temp = temp / (size(Attmps,1)-1);
    end
