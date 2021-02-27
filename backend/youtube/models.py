from django.db import models


class Channel(models.Model):
    id = models.CharField('channel_id', max_length=100, primary_key=True)
    name = models.CharField('channel_name', max_length=50)
    display_name = models.CharField('display_name', max_length=50)
    thumbnail = models.CharField('thumbnail', max_length=50)
    thumbnail_height = models.IntegerField('thumbnail_height')
    thumbnail_width = models.IntegerField('thumbnail_width')
    created_at = models.DateTimeField('created_at', auto_now_add=True)
    updated_at = models.DateTimeField('updated_at', auto_now=True)


class Video(models.Model):
    id = models.CharField('video_id', max_length=100, primary_key=True)
    title = models.CharField('title', max_length=100)
    description = models.TextField('description')
    display_name = models.CharField('display_name', max_length=50)
    thumbnail = models.CharField('thumbnail', max_length=50)
    thumbnail_height = models.IntegerField('thumbnail_height')
    thumbnail_width = models.IntegerField('thumbnail_width')
    created_at = models.DateTimeField('created_at', auto_now_add=True)
    updated_at = models.DateTimeField('updated_at', auto_now=True)

    channel = models.ForeignKey(Channel, on_delete=models.CASCADE)


class VideoDetail(models.Model):
    id = models.CharField('movie_detail_id', max_length=100, primary_key=True)
    view_count = models.IntegerField('view_count')
    like_count = models.IntegerField('like_count')
    dislike_count = models.IntegerField('dislike_count')
    favorite_count = models.IntegerField('favorite_count')
    comment_count = models.IntegerField('comment_count')
    created_at = models.DateTimeField('created_at', auto_now_add=True)
    updated_at = models.DateTimeField('updated_at', auto_now=True)

    movie = models.ForeignKey(Video, on_delete=models.CASCADE)

