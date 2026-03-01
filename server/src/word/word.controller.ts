import { Controller, Post, Body, HttpException, HttpStatus } from '@nestjs/common';
import { WordService } from './word.service';
import { WordAnalysisResult } from './types';

interface AnalyzeWordDto {
  word: string;
}

@Controller('word')
export class WordController {
  constructor(private readonly wordService: WordService) {}

  @Post('analyze')
  async analyzeWord(@Body() body: AnalyzeWordDto): Promise<{ code: number; msg: string; data: WordAnalysisResult }> {
    console.log('收到单词分析请求:', body);

    if (!body.word || typeof body.word !== 'string') {
      throw new HttpException('单词不能为空', HttpStatus.BAD_REQUEST);
    }

    try {
      const result = await this.wordService.analyzeWord(body.word.trim());

      console.log('单词分析成功:', result);

      return {
        code: 200,
        msg: 'success',
        data: result,
      };
    } catch (error) {
      console.error('单词分析失败:', error);
      throw new HttpException(
        error.message || '分析失败，请重试',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
