-- 1
SELECT DisplayName, Location, Reputation
FROM Users
ORDER BY Reputation DESC;

-- 2 

SELECT Posts.Title, Users.DisplayName
FROM Posts
INNER JOIN Users ON Posts.OwnerUserId = Users.Id
WHERE Posts.OwnerUserId IS NOT NULL;

-- 3
SELECT Users.DisplayName, AVG(Posts.Score) AS AverageScore
FROM Posts
INNER JOIN Users ON Posts.OwnerUserId = Users.Id
GROUP BY Users.DisplayName;


-- 4
SELECT Users.DisplayName
FROM Users
WHERE Users.Id IN (
    SELECT Comments.UserId
    FROM Comments
    GROUP BY Comments.UserId
    HAVING COUNT(Comments.Id) > 100
);


-- 5
UPDATE Users
SET Location = 'Desconocido'
WHERE Location IS NULL OR Location = '';

-- 6
BEGIN TRANSACTION;

DELETE FROM Comments
WHERE UserId IN (
    SELECT Id
    FROM Users
    WHERE Reputation < 100
);

DECLARE @RowsAffected INT;
SET @RowsAffected = @@ROWCOUNT;

PRINT CAST(@RowsAffected AS VARCHAR(10)) + ' comentarios fueron eliminados.';

COMMIT TRANSACTION;

-- 7
SELECT 
    Users.DisplayName,
    COALESCE(PostCounts.TotalPosts, 0) AS TotalPosts,
    COALESCE(CommentCounts.TotalComments, 0) AS TotalComments,
    COALESCE(BadgeCounts.TotalBadges, 0) AS TotalBadges
FROM 
    Users
LEFT JOIN 
    (SELECT OwnerUserId, COUNT(*) AS TotalPosts FROM Posts GROUP BY OwnerUserId) AS PostCounts
    ON Users.Id = PostCounts.OwnerUserId
LEFT JOIN 
    (SELECT UserId, COUNT(*) AS TotalComments FROM Comments GROUP BY UserId) AS CommentCounts
    ON Users.Id = CommentCounts.UserId
LEFT JOIN 
    (SELECT UserId, COUNT(*) AS TotalBadges FROM Badges GROUP BY UserId) AS BadgeCounts
    ON Users.Id = BadgeCounts.UserId;

-- 8
SELECT TOP 10 Title, Score
FROM Posts
ORDER BY Score DESC;

-- 9
SELECT TOP 5 Text, CreationDate
FROM Comments
ORDER BY CreationDate DESC;
