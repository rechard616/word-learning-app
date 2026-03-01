import { Injectable } from '@nestjs/common';
import { TTSClient, Config } from 'coze-coding-dev-sdk';
import { HeaderUtils } from 'coze-coding-dev-sdk';

@Injectable()
export class TtsService {
  private ttsClient: TTSClient;

  constructor() {
    const config = new Config();
    const customHeaders = HeaderUtils.extractForwardHeaders({});
    this.ttsClient = new TTSClient(config, customHeaders);
  }

  async synthesize(text: string, uid: string = 'default'): Promise<{ audioUri: string }> {
    if (!text || typeof text !== 'string') {
      throw new Error('文本不能为空');
    }

    try {
      console.log('TTS 请求:', { text, uid });

      const response = await this.ttsClient.synthesize({
        uid,
        text,
        speaker: 'zh_female_xiaohe_uranus_bigtts',
        audioFormat: 'mp3',
        sampleRate: 24000,
      });

      console.log('TTS 响应:', { audioUri: response.audioUri, audioSize: response.audioSize });

      return {
        audioUri: response.audioUri,
      };
    } catch (error) {
      console.error('语音合成失败:', error);
      throw new Error('语音合成失败，请重试');
    }
  }
}
