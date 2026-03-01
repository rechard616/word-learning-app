import { Injectable } from '@nestjs/common';
import { LLMClient, Config } from 'coze-coding-dev-sdk';
import { HeaderUtils } from 'coze-coding-dev-sdk';
import { WordAnalysisResult } from './types';

@Injectable()
export class WordService {
  private llmClient: LLMClient;

  constructor() {
    const config = new Config();
    const customHeaders = HeaderUtils.extractForwardHeaders({});
    this.llmClient = new LLMClient(config, customHeaders);
  }

  async analyzeWord(word: string): Promise<WordAnalysisResult> {
    const systemPrompt = `You are a professional English dictionary assistant. Your task is to analyze English words and provide accurate information.

Please analyze the word and provide the following information:
1. Word (单词)
2. Phonetic (音标) - Use IPA format, e.g., /həˈləʊ/
3. Part of Speech (词性) - e.g., noun, verb, adjective, etc.
4. Meaning (中文意思) - Provide the most common Chinese meaning
5. Example Sentence (例句) - Provide a simple and practical English example sentence

Return the result in JSON format only, without any additional text or explanation:
{
  "word": "original word",
  "phonetic": "IPA phonetic",
  "partOfSpeech": "part of speech",
  "meaning": "Chinese meaning",
  "example": "English example sentence"
}`;

    try {
      const messages = [
        { role: 'system' as const, content: systemPrompt },
        { role: 'user' as const, content: word },
      ];

      console.log('LLM 请求:', { word, messages });

      const response = await this.llmClient.invoke(messages, {
        model: 'doubao-seed-1-8-251228',
        temperature: 0.3,
      });

      console.log('LLM 响应:', response.content);

      // 解析 JSON 响应
      const jsonMatch = response.content.match(/\{[\s\S]*\}/);
      if (!jsonMatch) {
        throw new Error('无法解析 LLM 响应');
      }

      const result: WordAnalysisResult = JSON.parse(jsonMatch[0]);

      // 验证响应数据
      if (!result.word || !result.phonetic || !result.partOfSpeech || !result.meaning || !result.example) {
        throw new Error('响应数据不完整');
      }

      return result;
    } catch (error) {
      console.error('单词分析失败:', error);
      throw new Error('单词分析失败，请重试');
    }
  }
}
