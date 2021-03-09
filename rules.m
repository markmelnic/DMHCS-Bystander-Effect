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

%DDR2a Interpretation of robbery
function result = ddr2a(trace, params, t)
    result = {};
    for number_of_bystanders = l2.getall(trace, t, 'number_of_bystanders', {NaN})
        bystanders = number_of_bystanders.arg{1};
        for observing_a_situation = l2.getall(trace, t, 'observing_a_situation', {NaN})
            situation = observing_a_situation.arg{1};
            if situation == "robbery"
                if bystanders < 3
                    interpretation = 'emergency';
                else
                    interpretation = 'normal';
                end
                result = {result{:} {t+1, 'interpretation_of_situation', {interpretation}}};
            end
        end
    end
end

%DDR2b Interpretation of accident
function result = ddr2b(trace, params, t)
    result = {};
    for number_of_bystanders = l2.getall(trace, t, 'number_of_bystanders', {NaN})
        bystanders = number_of_bystanders.arg{1};
        for observing_a_situation = l2.getall(trace, t, 'observing_a_situation', {NaN})
            situation = observing_a_situation.arg{1};
            if situation == "accident"
                if bystanders < 5
                    interpretation = 'emergency';
                else
                    interpretation = 'normal';
                end
                result = {result{:} {t+1, 'interpretation_of_situation', {interpretation}}};
            end
        end
    end
end

%DDR3 Decision to intervene
function result = ddr3(trace, params, t)
    result = {};
    for interpretation_of_situation = l2.getall(trace, t, 'interpretation_of_situation', {NaN})
        interpretation = interpretation_of_situation.arg{1};
        for degree_of_responsibility = l2.getall(trace, t, 'degree_of_responsibility', {NaN})
            responsibility = degree_of_responsibility.arg{1};
            if interpretation == "emergency" && responsibility > 50
                action = 'intervene';
            else
                action = 'none'
            end
            result = {result{:} {t+1, 'form_of_assistance', {action}}};
        end
    end
end