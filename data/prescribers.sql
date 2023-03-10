1. 
 a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
	
select *
From prescription

select npi, SUM(total_claim_count) AS total_claims
from prescriber
inner join prescription 
USING(npi)
Group By npi
Order by total_claims DESC
Limit 1;
--- npi # 1881634483 had a total claim of 99707 which was the highest. 

b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.

select npi, nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, SUM(total_claim_count) AS total_claims
from prescriber
inner join prescription 
USING(npi)
Group By npi, nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description
Order by total_claims DESC;

2. 

a. Which specialty had the most total number of claims (totaled over all drugs)?
	
SELECT p.specialty_description, SUM(pr.total_claim_count) AS total_claims
FROM prescriber p
JOIN prescription pr ON p.npi = pr.npi
GROUP BY p.specialty_description
ORDER BY total_claims DESC;

 b. Which specialty had the most total number of claims for opioids?
	
SELECT specialty_description, opioid_drug_flag, SUM(total_claim_count) AS total_claims
FROM prescriber
JOIN prescription 
USING(npi)
JOIN drug
USING(drug_name)
Where opioid_drug_flag = 'Y'
GROUP BY specialty_description, opioid_drug_flag
ORDER BY total_claims DESC;

    c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

    d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

3. 
    a. Which drug (generic_name) had the highest total drug cost?
	
select generic_name, SUM(total_drug_cost) AS total_drug
from drug
Inner join prescription
Using(drug_name)
group by generic_name
order by total_drug DESC;

-- Insulin Glargine, Hum, Rec, Anlog had the highest drug cost.

    b. Which drug (generic_name) has the hightest total cost per day?

select generic_name, SUM(total_drug_cost/total_day_supply) AS total_cost_per_day
from drug
Inner join prescription
Using(drug_name)
group by generic_name
order by total_cost_per_day DESC;

**Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**
	
select generic_name, ROUND(SUM(total_drug_cost/total_day_supply),2) AS total_cost_per_day
from drug
Inner join prescription
Using(drug_name)
group by generic_name
order by total_cost_per_day DESC;
4. 
a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.

SELECT drug_name AS drug_name,
    CASE 
        WHEN opioid_drug_flag = 'Y' THEN 'opioid'
        WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
        ELSE 'neither'
		END AS drug_type
		From drug;
b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.

SELECT 
    d.drug_name,
    CASE
        WHEN d.opioid_drug_flag = 'Y' THEN 'opioid'
        WHEN d.antibiotic_drug_flag = 'Y' THEN 'antibiotic'
        ELSE 'neither'
    END AS drug_type,
    SUM(p.total_drug_cost) AS total_cost	
FROM 
    drug AS d
    JOIN prescription p ON d.drug_name = p.drug_name
GROUP BY 
    d.drug_name,
    drug_type
ORDER BY 
    total_cost DESC

5. 
    a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.
	
SELECT COUNT(cbsa) AS num_cbsas
FROM cbsa
JOIN fips_county ON cbsa.fipscounty = fips_county.fipscounty
WHERE fips_county.state = 'TN';

b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

SELECT p.fipscounty, pc.county, p.population
FROM population p
JOIN fips_county pc ON p.fipscounty = pc.fipscounty
LEFT JOIN cbsa c ON pc.fipscounty = c.fipscounty
WHERE c.fipscounty IS NULL
ORDER BY p.population DESC
LIMIT 1

SELECT p.fipscounty, pc.county, p.population
FROM population p
JOIN fips_county pc ON p.fipscounty = pc.fipscounty
LEFT JOIN cbsa c ON pc.fipscounty = c.fipscounty
WHERE c.fipscounty IS NULL
ORDER BY p.population ASC
Limit 1

c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

SELECT *
FROM population


select *
from cbsa

select cbsaname, population
from cbsa
inner join population
using(fipscounty)
order by population DESC

6. 
    a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.
	
SELECT drug_name, total_claim_count
FROM prescription
WHERE total_claim_count >= 3000;

b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

 c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

    a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Managment') in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

    b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
    
    c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.
