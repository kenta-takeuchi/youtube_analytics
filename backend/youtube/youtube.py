from apiclient.discovery import build
from decouple import config

from backend.youtube.error import (
    NoChannelError,
    NoMovieError,
    NoMovieDetailError,
)


YOUTUBE_API_KEY = config('YOUTUBE_API_KEY')


class YoutubeService:
    """
    YoutubeAPIドキュメント
    https://developers.google.com/youtube/v3/docs?hl=ja
    """
    def __init__(self):
        self.__youtube = build('youtube', 'v3', developerKey=YOUTUBE_API_KEY)

    def get_channel_by_channel_id(self, channel_id: str) -> str:
        """
        チャンネル情報を取得する
        :param channel_id: チャンネルID
        :return: チェンネル情報
        """
        channels_response = self.__youtube.channels().list(
            part='snippet',
            id=channel_id
        ).execute()

        if channels_response['items'] is None:
            raise NoChannelError(f"Channel Not found. channel_id: {channel_id}")
        return channels_response['items'][0]

    def get_videos_by_channel_id(self, channel_id: str) -> list:
        """
        チャンネルに投稿されている動画一覧を取得する
        :param channel_id: チャンネルID
        :return: 動画情報一覧
        """
        videos_response = self.__youtube.search().list(
            part='snippet',
            channelId=channel_id,
            type='video',
            maxResults=2,
        ).execute()

        if videos_response['items'] is None:
            raise NoMovieError(f"Video not found. channel_id: {channel_id}")
        return videos_response['items']

    def get_videos_detail_by_video_id(self, video_id: str):
        """
        再生数・いいね数・コメント数などの動画情報を取得する
        :param video_id: 動画ID
        :return: 動画詳細情報
        """
        video_detail_response = self.__youtube.videos().list(
            part='statistics',
            id=video_id,
        ).execute()
        if video_detail_response['items'] is None:
            raise NoMovieDetailError(f'Video detail not found. video_id: {video_id}')
        return video_detail_response['items']
