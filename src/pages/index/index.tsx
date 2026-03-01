import { View, Text, Input, Button } from '@tarojs/components';
import { useState, useRef } from 'react';
import Taro, { InnerAudioContext } from '@tarojs/taro';
import { Network } from '@/network';
import { Volume2 } from 'lucide-react-taro';
import './index.css';

interface WordAnalysis {
  word: string;
  phonetic: string;
  partOfSpeech: string;
  meaning: string;
  example: string;
}

const IndexPage = () => {
  const [wordInput, setWordInput] = useState('');
  const [analyzing, setAnalyzing] = useState(false);
  const [result, setResult] = useState<WordAnalysis | null>(null);
  const [playingWord, setPlayingWord] = useState(false);
  const [playingExample, setPlayingExample] = useState(false);

  const wordAudioRef = useRef<InnerAudioContext | null>(null);
  const exampleAudioRef = useRef<InnerAudioContext | null>(null);

  // 分析单词
  const handleAnalyze = async () => {
    if (!wordInput.trim()) {
      Taro.showToast({
        title: '请输入单词',
        icon: 'none'
      });
      return;
    }

    setAnalyzing(true);
    setResult(null);

    try {
      console.log('发送单词分析请求:', { url: '/api/word/analyze', method: 'POST', data: { word: wordInput.trim() } });

      const response = await Network.request({
        url: '/api/word/analyze',
        method: 'POST',
        data: { word: wordInput.trim() }
      });

      console.log('收到单词分析响应:', response.data);

      if (response.data.code === 200 && response.data.data) {
        setResult(response.data.data);
        Taro.showToast({
          title: '分析成功',
          icon: 'success'
        });
      } else {
        throw new Error(response.data.msg || '分析失败');
      }
    } catch (error: any) {
      console.error('单词分析失败:', error);
      Taro.showToast({
        title: error.message || '分析失败，请重试',
        icon: 'none'
      });
    } finally {
      setAnalyzing(false);
    }
  };

  // 播放音频
  const playAudio = async (text: string, type: 'word' | 'example') => {
    const isWord = type === 'word';
    const setPlaying = isWord ? setPlayingWord : setPlayingExample;

    if (isWord ? playingWord : playingExample) {
      // 停止播放
      if (isWord && wordAudioRef.current) {
        wordAudioRef.current.stop();
        wordAudioRef.current.destroy();
        wordAudioRef.current = null;
      }
      if (!isWord && exampleAudioRef.current) {
        exampleAudioRef.current.stop();
        exampleAudioRef.current.destroy();
        exampleAudioRef.current = null;
      }
      setPlaying(false);
      return;
    }

    setPlaying(true);

    try {
      console.log('发送语音合成请求:', { url: '/api/tts/synthesize', method: 'POST', data: { text } });

      const response = await Network.request({
        url: '/api/tts/synthesize',
        method: 'POST',
        data: { text }
      });

      console.log('收到语音合成响应:', response.data);

      if (response.data.code === 200 && response.data.data && response.data.data.audioUri) {
        const audioUri = response.data.data.audioUri;
        const audioContext = Taro.createInnerAudioContext();
        audioContext.src = audioUri;

        if (isWord) {
          wordAudioRef.current = audioContext;
        } else {
          exampleAudioRef.current = audioContext;
        }

        audioContext.onEnded(() => {
          setPlaying(false);
          audioContext.destroy();
          if (isWord) {
            wordAudioRef.current = null;
          } else {
            exampleAudioRef.current = null;
          }
        });

        audioContext.onError((err) => {
          console.error('音频播放失败:', err);
          setPlaying(false);
          audioContext.destroy();
          if (isWord) {
            wordAudioRef.current = null;
          } else {
            exampleAudioRef.current = null;
          }
          Taro.showToast({
            title: '播放失败',
            icon: 'none'
          });
        });

        audioContext.play();
      } else {
        throw new Error(response.data.msg || '语音合成失败');
      }
    } catch (error: any) {
      console.error('语音合成失败:', error);
      setPlaying(false);
      Taro.showToast({
        title: error.message || '播放失败，请重试',
        icon: 'none'
      });
    }
  };

  return (
    <View className="flex flex-col h-full bg-gray-50">
      {/* 顶部输入区域 */}
      <View className="bg-white p-4 shadow-sm">
        <Text className="block text-2xl font-bold text-blue-600 mb-4 text-center">单词学习助手</Text>
        <View className="bg-white rounded-xl shadow-sm mb-4">
          <View className="px-4 py-3">
            <Input
              className="w-full text-base bg-transparent"
              placeholder="请输入单词"
              placeholderClass="text-gray-400"
              value={wordInput}
              onInput={(e) => setWordInput(e.detail.value)}
            />
          </View>
        </View>
        <Button
          onClick={handleAnalyze}
          disabled={analyzing}
          className="w-full bg-blue-500 text-white rounded-xl py-3 text-base font-medium"
        >
          {analyzing ? '分析中...' : '开始分析'}
        </Button>
      </View>

      {/* 结果展示区域 */}
      <View className="flex-1 p-4 overflow-auto">
        {analyzing && (
          <View className="flex items-center justify-center py-16">
            <Text className="block text-base text-blue-500">正在分析单词...</Text>
          </View>
        )}

        {result && !analyzing && (
          <View className="bg-white rounded-2xl p-6 shadow-sm mb-4">
            {/* 单词和音标 */}
            <View className="mb-4">
              <Text className="block text-2xl font-bold text-blue-600 mb-2">{result.word}</Text>
              <Text className="block text-sm text-gray-500 italic">{result.phonetic}</Text>
            </View>

            {/* 词性 */}
            <View className="mb-4">
              <View className="flex items-center gap-2">
                <View className="bg-blue-100 text-blue-700 px-3 py-1 rounded-full">
                  <Text className="block text-sm">{result.partOfSpeech}</Text>
                </View>
              </View>
            </View>

            {/* 中文意思 */}
            <View className="mb-4">
              <Text className="block text-sm text-gray-500 mb-2">中文意思</Text>
              <Text className="block text-base text-gray-900 font-medium">{result.meaning}</Text>
            </View>

            {/* 例句 */}
            <View className="border-t border-gray-200 pt-4">
              <Text className="block text-sm text-gray-500 mb-2">例句</Text>
              <Text className="block text-base text-gray-700 leading-relaxed">{result.example}</Text>
            </View>

            {/* 朗读按钮 */}
            <View className="flex items-center justify-center gap-3 mt-6">
              <View style={{ flex: 1 }}>
                <Button
                  onClick={() => playAudio(result.word, 'word')}
                  disabled={playingExample}
                  className={`w-full rounded-xl py-3 text-base font-medium flex items-center justify-center gap-2 ${
                    playingWord ? 'bg-gray-400 text-white' : 'bg-green-500 text-white'
                  }`}
                >
                  <Volume2 size={20} color={playingWord ? '#fff' : '#fff'} />
                  <Text className="block">{playingWord ? '停止' : '朗读单词'}</Text>
                </Button>
              </View>
              <View style={{ flex: 1 }}>
                <Button
                  onClick={() => playAudio(result.example, 'example')}
                  disabled={playingWord}
                  className={`w-full rounded-xl py-3 text-base font-medium flex items-center justify-center gap-2 ${
                    playingExample ? 'bg-gray-400 text-white' : 'bg-indigo-500 text-white'
                  }`}
                >
                  <Volume2 size={20} color={playingExample ? '#fff' : '#fff'} />
                  <Text className="block">{playingExample ? '停止' : '朗读例句'}</Text>
                </Button>
              </View>
            </View>
          </View>
        )}

        {!result && !analyzing && (
          <View className="flex flex-col items-center justify-center py-16">
            <Text className="block text-6xl mb-4">📚</Text>
            <Text className="block text-lg font-semibold text-gray-900 mb-2">开始学习</Text>
            <Text className="block text-base text-gray-500">输入单词，智能分析词性、音标和例句</Text>
          </View>
        )}
      </View>
    </View>
  );
};

export default IndexPage;
