--QUESTION 1
SELECT COUNT (*) FROM users;

--QUESTION 2
SELECT COUNT (*) FROM transfers
WHERE send_amount_currency = 'CFA' AND
          ((Kind = 'transfer') OR (Kind = 'payment'));
		  
--QUESTION 3
SELECT COUNT(DISTINCT(u_id)) FROM transfers
WHERE send_amount_currency = 'CFA' AND
          ((Kind = 'transfer') OR (Kind = 'payment'));
		  
--QUESTION 4
SELECT COUNT(atx_id) FROM agent_transactions
WHERE EXTRACT(YEAR FROM when_created) = 2018
GROUP BY EXTRACT(MONTH FROM when_created);

--QUESTION 5
SELECT COUNT(A.amount) AS net_depositor, COUNT(B.amount) AS net_withdrawer, B.when_created
    FROM agent_transactions A, agent_transactions B
    WHERE (A.amount < 0 OR B.amount > 0)
    AND B.when_created BETWEEN '2020-07-12' AND '2020-07-18'
    GROUP BY B.when_created;

--QUESTION 6
SELECT City, Volume INTO atx_volume_city_summary FROM 
(SELECT agents.city AS City, count(agent_transactions.atx_id) AS Volume FROM agents 
INNER JOIN agent_transactions 
ON agents.agent_id = agent_transactions.agent_id 
WHERE (agent_transactions.time_created > (NOW() - INTERVAL '1 week')) 
GROUP BY agents.city) as atx_volume_summary; 

--QUESTION 7
SELECT City, Volume, Country INTO atx_volume_city_summary_with_Country 
FROM ( Select agents.city AS City, agents.country AS Country, count(agent_transactions.atx_id) AS Volume FROM agents 
INNER JOIN agent_transactions 
ON agents.agent_id = agent_transactions.agent_id 
WHERE (agent_transactions.time_created > (NOW() - INTERVAL '1 week')) 
GROUP BY agents.country,agents.city) as atx_volume_summary_with_Country;

--QUESTION 8
SELECT sum(transfers.send_amount_scalar) AS Volume, transfers.kind AS transfer_kind, wallets.ledger_location AS Country 
FROM transfers 
INNER JOIN wallets 
ON transfers.source_wallet_id = wallets.wallet_id where (transfers.time_created > (NOW() - INTERVAL '1 week'))
GROUP BY wallets.ledger_location, transfers.kind;

--QUESTION 9
SELECT count(transfer_id) AS Transaction_count, count(transfers.source_wallet_id) AS Unique_Senders, 
transfers.kind AS transfer_Kind, wallets.ledger_location AS Country, sum(transfers.send_amount_scalar) AS Volume FROM transfers 
INNER JOIN wallets 
ON transfers.source_wallet_id = wallets.wallet_id where (transfers.time_created > (NOW() - INTERVAL '1 week'))
GROUP BY wallets.ledger_location, transfers.kind; 

--QUESTION 10
SELECT source_wallet_id, send_amount_scalar FROM transfers 
WHERE send_amount_currency = 'CFA' 
AND (send_amount_scalar>10000000) 
AND (transfers.time_created > (NOW() - INTERVAL '1 month'));