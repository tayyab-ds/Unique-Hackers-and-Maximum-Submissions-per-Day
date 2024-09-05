WITH CTE AS(
    SELECT 
        s.submissiondate, 
        s.hackerid, 
        h.name,
        --count(*) submissions, 
        ROW_NUMBER() OVER(PARTITION BY  s.submissiondate  ORDER BY count(*) desc, s.hackerid) as day_rank,
        DENSE_RANK() OVER(ORDER BY s.submissiondate) as day_number,
        DENSE_RANK() OVER(PARTITION BY s.hackerid ORDER BY s.submissiondate) as day_hacker
    FROM Submissions s
    INNER JOIN Hackers h
    ON s.hackerid = h.hackerid
    GROUP BY s.submissiondate, s.hackerid, h.name

    )
    
    SELECT submissiondate AS SubmissionDate,
                 SUM(CASE WHEN day_number = day_hacker THEN 1 ELSE 0 END) AS Submissions,
                 MIN( CASE WHEN day_rank = 1 THEN  hackerid END) AS HackerId,
                 MIN(CASE WHEN day_rank = 1 THEN  name END) AS Name