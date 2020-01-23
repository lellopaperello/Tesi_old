function [check, isterminal, direction] = terminal_velocity(~, ~, ~)

global Equal

check = double(Equal) ; % Doesn't accept bool
isterminal = 1 ;        % stop integration when event occurs
direction = 0 ;         % from both directions (positive and negative)

end


