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
                if bystanders < params.roberry_bystanders
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
                if bystanders < params.accident_bystanders
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
                action = 'none';
            end
            result = {result{:} {t+1, 'form_of_assistance', {action}}};
        end
    end
end

%SDR1a Desire form of assistance
function result = sdr1a(trace, params, t)
    result = {};
    for form_of_assistance = l2.getall(trace, t, 'form_of_assistance', {NaN})
        action = form_of_assistance.arg{1};
        if strcmp(action, 'intervene')
           action = 'intervene';
       result = {result{:} {t+1, 'desire', predicate('form_of_assistance', {action})}};
        end
     end  
end

%SDR1b Desire interpretation
function result = sdr1b( trace, params, t)
    result = {};
    for desires_assistance = l2.getall(trace, t, 'desire', {predicate('form_of_assistance', {NaN})})
        assistance = desires_assistance.arg{1}.arg{1};
        if assistance == "intervene"
            interpretation = 'emergency'; 
        result = { result{:} {t+1, 'desire', {predicate('interpretation_of_situation', {interpretation})}} };
        end 
    end
end

%SDR 2 Desire to send message
function result = sdr2( trace, params, t)
    result = {};
    for desires_interpretation = l2.getall(trace, t, 'desire', {predicate('interpretation_of_situation', {NaN})})
        interpretation = desires_interpretation.arg{1}.arg{1};
        if interpretation == "emergency"
            message = true; 
        result = { result{:} {t+1, 'desire', {predicate('send_message', {message})}} };
        end 
    end
end

%SDR 3 Propose to send message
function result = sdr3(trace, params, t)
    result = {};
    for desires_message = l2.getall(trace, t, 'desire', {predicate('send_message', {NaN})})
        message_desire = desires_message.arg{1}.arg{1};
        if message_desire == true
            desires = 'send message';
        result = {result{:} {t+1, 'propose', {desires}}};
        end
    end
end
