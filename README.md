# atliq_internship

The dataset contains 5,198 YouTube videos from Netflix India with the following key columns:

video_id: Unique identifier for each video.
title: Video title.
description: Video description.
tags: List of tags associated with the video.
publishedAt: Date and time when the video was published.
viewCount: Number of views.
likeCount: Number of likes.
commentCount: Number of comments.
duration: Video length (stored as a string in ISO 8601 format).

Key Findings from the Analysis:
Duration Influence on Views & Comments:

The average video duration is approximately 4.5 minutes (271 seconds).
The longest video is 2 hours 51 minutes, while the shortest is 0 seconds (possibly removed or a live event).
A deeper correlation check will determine if longer videos get more views/comments.
Relationship Between Views & Comments:

The average video has ~2.15 million views and ~654 comments.
The highest comment count is 59,038.
A correlation analysis will reveal if more views drive more comments.
Tag Count Impact on Views:

The average number of tags used is 18, with a max of 48.
Some videos have 0 tags but might still perform well.
Publishing Day/Time Influence on Engagement:

Videos are published at an average time of 9:30 AM.
The publishing day distribution will help identify peak engagement times.
Most Popular Video Breakdown:

The most viewed video has 888.3 million views.
