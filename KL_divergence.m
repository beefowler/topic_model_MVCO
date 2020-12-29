%Caculate KL Divergence for a particular model, across the time series

%Inputs: 3 matrices.
%Observations is a matrix, wordlist, based on Blast Results
%topic_model = readtable("topicmodel.csv"); topic_model = topic_model{:,:}; 
%topic_maxl = readtable("topics.maxlikelihood.csv"); topic_maxl = topic_maxl{:,:}; 

function [KLD] = KL_divergence(topic_model, topic_maxl, observations)

observations = sort(observations, 1); %to ensure lines up with topic_maxl
if topic_maxl(:,1) ~= observations(:,1)
    disp('observations and model times don"t align')
    return 
end

%for indexing add 1 to topic labels, now topic 1 is row 1 of topic_model
topic_maxl = topic_maxl+1; 

n_obs = size(observations, 1); 
[n_tops, n_vocab] = size(topic_model); 

KLD = nan(1, n_obs); 

for d = 1:n_obs
    %figure out estimated proportions of each topic
    F = histcounts(topic_maxl(d, 2:end), 1:n_tops+1); 
    F = (F./sum(F))'; %scale to 1
    F = repmat(F, 1, n_vocab); 
    
    P = topic_model  ./ sum(topic_model, 2); 
    %probabilities of each word for each topic
    
    %combine topics in appropriate proportions 
    p = dot(F, P, 1); 
    % p is total expected probability for each word on this day. 
    
    clear F P
    
    %now we need q values for each of the words
    q = histcounts(observations(d,2:end), 1:n_vocab+1); 
    q = q./sum(q); 
    
    
    %%NEED TO FIGURE OUT HOW TO RESOLVE 0s and Infs 
    p(p==0) = NaN; %KL divergence is only calculated for events in P
    
    not0 = min(min(q(q>0)), 3e-5); %replace 0's in q with negligably small value
    q(q==0) = not0*ones(1,sum(q==0)) ; 
    
    KL = nansum(p.* log(p./q)); %KL divergence is expected value of p/q
    KLD(d) = KL; %save day's KL to output vector
    
end
