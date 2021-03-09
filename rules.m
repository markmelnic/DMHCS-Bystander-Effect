function [ fncs ] = rules()
    % DO NOT EDIT
    fncs = l2.getRules();
    for i=1:length(fncs)
        fncs{i} = str2func(fncs{i});
    end
end

%DDR1 Degree of responsibility
function result = ddr1(trace, params, t)
    result = {};
    for ability_to_help = l2.getall(trace, t, 'ability_to_help', {NaN})
        ability = ability_to_help.arg{1};
        for number_of_bystanders = l2.getall(trace, t, 'number_of_bystanders', {NaN})
            bystanders = number_of_bystanders.arg{1};
            if ability && bystanders > 0
                responsibility_value = ability / bystanders;
                result = {result{:} {t+1, 'degree_of_responsibility', {responsibility_value}}};
            end
        end 
    end
end

%DDR2 Interpretation of robbery 