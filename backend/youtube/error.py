class YoutubeError(Exception):
    """youtube apiに関するエラー基底クラス"""


class NoChannelError(YoutubeError):
    """チャンネルが見つからなかった時のエラークラス"""


class NoMovieError(YoutubeError):
    """動画が見つからなかった時のエラークラス"""


class NetworkAccessError(YoutubeError):
    """ネットワークエラー時のエラークラス"""
