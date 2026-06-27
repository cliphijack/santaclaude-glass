<script def>
{
  "navigationBarTitleText": "산타클로드",
  "description": "웹 Claude Code인 산타클로드와 로키드 글래스를 연결한다. 내 Claude(루돌프)에게 작업을 시킨다 — 쇼츠 대본 뽑기, 블로그 발행, 코드 작성, 작업 상태 확인. '루돌프 굴려', '쇼츠 뽑아', '블로그 써', '지금 뭐 하고 있어' 같은 말에 반응한다.",
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
// TODO: 나중에 토큰 입력 UI/저장으로 교체. 지금은 여기 한 줄만 채우면 됨.
const TOKEN = '';

export default {
  data: {
    cmd: '',
    loading: false,
    result: ''
  },

  onLoad(query) {
    const cmd = (query && query.command) || '쇼츠 뽑아';   // 테스트: 음성/입력 없이도 Run하면 자동 실행
    this.setData({ cmd: cmd });
    this.run(cmd);
  },

  run(cmd) {
    this.setData({ cmd: cmd, loading: true, result: '' });
    wx.request({
      url: 'https://santaclaude.app/api/glass/exec',
      method: 'POST',
      header: { 'Content-Type': 'application/json' },
      data: { command: cmd, token: TOKEN },
      success: (res) => {
        const d = (res && res.data) || {};
        this.setData({ loading: false, result: d.message || d.err || '완료' });
      },
      fail: () => {
        this.setData({ loading: false, result: '⚠️ 연결 실패' });
      }
    });
  }
}
</script>

<page>
  <view class="wrap">
    <text class="hd">🦌 RUDOLPH · LIVE</text>
    <text class="cmd">{{ cmd || '대기 중' }}</text>
    <view ink:if="{{ loading }}">
      <text class="dim">⋯ 루돌프 작업 중_</text>
    </view>
    <view ink:else>
      <text class="ok">{{ result }}</text>
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
  margin-bottom: 24px;
  opacity: 0.85;
}
.cmd {
  color: #8affb0;
  font-size: 28px;
  line-height: 1.4;
  margin-bottom: 16px;
}
.dim {
  color: #33ff66;
  font-size: 24px;
  line-height: 1.4;
  opacity: 0.65;
}
.ok {
  color: #aaffcf;
  font-size: 28px;
  font-weight: bold;
  line-height: 1.4;
}
</style>
