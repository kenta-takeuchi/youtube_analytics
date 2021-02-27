from apiclient.discovery import build
from decouple import config

from .error import YoutubeError, NoMovieError, NoChannelError, NetworkAccessError

YOUTUBE_API_KEY = config('YOUTUBE_API_KEY')


class YoutubeService:
    def __init__(self):
        self.__youtube = build('youtube', 'v3', developerKey=YOUTUBE_API_KEY)

    def get_channel_by_channel_id(self, channel_id: str):
        channels_response = self.__youtube.channels().list(
            part=['snippet'],
            auth=YOUTUBE_API_KEY,
            id=[channel_id]
        ).execute()

        if channels_response['items'] is None:
            raise NoChannelError(f"Not found. channel_id: {channel_id}")

        return channels_response['items'][0]