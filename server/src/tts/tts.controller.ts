import { Controller, Post, Body, HttpException, HttpStatus } from '@nestjs/common';
import { TtsService } from './tts.service';

interface SynthesizeDto {
  text: string;
  uid?: string;
}

@Controller('tts')
export class TtsController {
  constructor(private readonly ttsService: TtsService) {}

  @Post('synthesize')
  async synthesize(@Body() body: SynthesizeDto) {
    console.log('收到语音合成请求:', body);

    if (!body.text || typeof body.text !== 'string') {
      throw new HttpException('文本不能为空', HttpStatus.BAD_REQUEST);
    }

    try {
      const result = await this.ttsService.synthesize(
        body.text.trim(),
        body.uid || 'default'
      );

      console.log('语音合成成功:', result);

      return {
        code: 200,
        msg: 'success',
        data: result,
      };
    } catch (error) {
      console.error('语音合成失败:', error);
      throw new HttpException(
        error.message || '语音合成失败，请重试',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
