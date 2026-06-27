<script def>
{
  "navigationBarTitleText": "산타클로드",
  "description": "산타클로드(SantaClaude)로 내 Claude(루돌프)에게 작업을 시킬 때. 쇼츠 대본 뽑기, 블로그 발행, 코드 작성, 작업 상태 확인 등 자연어 명령을 로컬 Claude로 실행하고 결과를 보여준다. '루돌프 굴려', '쇼츠 뽑아', '블로그 써', '상태 봐' 같은 말에 반응.",
  "schema": {
    "data": {
      "type": "object",
      "properties": {
        "command": {
          "type": "string",
          "description": "사용자의 자연어 작업 명령 (예: '쇼츠 대본 뽑아', '블로그 발행해', '지금 뭐 하고 있어')"
        }
      },
      "required": ["command"]
    }
  }
}
</script>

<script setup>
export default {
  data: {
    cmd: '',
    loading: true,
    result: ''
  },
  async onLoad(query) {
    const cmd = query.command || '대기 중';
    this.setData({ cmd, loading: true, result: '' });

    // TODO(2단계): santaclaude API 호출로 교체 (AIUI network request 문법 확인 후)
    //   const res = await request({
    //     url: 'https://santaclaude.app/api/glass/exec',
    //     method: 'POST',
    //     header: { 'Content-Type': 'application/json' },
    //     data: { command: cmd }
    //   });
    //   this.setData({ loading: false, result: res.data.summary });

    // 1단계: 더미 결과로 흐름·룩 확인
    setTimeout(() => {
      this.setData({
        loading: false,
        result: '대본 3개 생성 · 유튜브 업로드 완료'
      });
    }, 1500);
  }
}
</script>

<page>
  <view class="wrap">
    <text class="hd">🦌 RUDOLPH · LIVE</text>
    <text class="cmd">&gt; {{ cmd }}</text>
    <view ink:if="{{ loading }}">
      <text class="dim">⋯ 작업 중_</text>
    </view>
    <view ink:else>
      <text class="ok">✓ {{ result }}</text>
    </view>
  </view>
</page>

<style>
.wrap {
  display: flex;
  flex-direction: column;
  justify-content: center;
  height: 100vh;
  padding: 24px;
  background: #000000;
}
.hd {
  color: #33ff66;
  font-size: 22px;
  line-height: 1.3;
  margin-bottom: 26px;
  opacity: 0.85;
}
.cmd {
  color: #8affb0;
  font-size: 30px;
  line-height: 1.4;
  margin-bottom: 16px;
}
.dim {
  color: #33ff66;
  font-size: 28px;
  line-height: 1.4;
  opacity: 0.65;
}
.ok {
  color: #aaffcf;
  font-size: 30px;
  font-weight: 700;
  line-height: 1.4;
}
</style>
