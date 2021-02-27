from django.test import TestCase

from .youtube import YoutubeService


class TestYoutubeService(TestCase):
    # TODO 外部API使用箇所をMockにする

    @classmethod
    def setUpClass(cls):
        super(TestYoutubeService, cls).setUpClass()
        cls.youtube_service = YoutubeService()

    def test_get_channel_by_channel_id(self):
        result = 'UC9zY_E8mcAo_Oq772LEZq8Q'
        channel_response = self.youtube_service.get_channel_by_channel_id('UC9zY_E8mcAo_Oq772LEZq8Q')
        self.assertEqual(channel_response['id'], result)

    def test_get_videos_by_channel_id(self):
        result = 'UC9zY_E8mcAo_Oq772LEZq8Q'
        videos_response = self.youtube_service.get_videos_by_channel_id('UC9zY_E8mcAo_Oq772LEZq8Q')
        self.assertEqual(videos_response[0]['snippet']['channelId'], result)

    def test_get_videos_detail_by_video_id(self):
        video_detail_response = self.youtube_service.get_videos_detail_by_video_id('impSuIygMiQ')
        self.assertNotEqual(len(video_detail_response), 0)
