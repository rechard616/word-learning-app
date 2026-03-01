import { Module } from '@nestjs/common';
import { AppController } from '@/app.controller';
import { AppService } from '@/app.service';
import { WordModule } from '@/word/word.module';
import { TtsModule } from '@/tts/tts.module';

@Module({
  imports: [WordModule, TtsModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
