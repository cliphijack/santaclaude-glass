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
export default {
  data: {
    cmd: '',
    loading: false,
    result: '',
    token: '',
    tokenInput: '',
    ready: false
  },

  onLoad(query) {
    let token = '';
    try { token = wx.getStorageSync('sc_token') || ''; } catch (e) {}
    const cmd = (query && query.command) || '';
    this.setData({ token: token, cmd: cmd, ready: !!token });
    if (token && cmd) this.run(cmd, token);
  },

  onTokenInput(e) {
    this.setData({ tokenInput: (e && e.detail && e.detail.value) || '' });
  },

  saveToken() {
    const t = (this.data.tokenInput || '').trim();
    if (!t) return;
    try { wx.setStorageSync('sc_token', t); } catch (e) {}
    this.setData({ token: t, ready: true });
    if (this.data.cmd) this.run(this.data.cmd, t);
  },

  run(cmd, token) {
    this.setData({ cmd: cmd, loading: true, result: '' });
    wx.request({
      url: 'https://santaclaude.app/api/glass/exec',
      method: 'POST',
      header: { 'Content-Type': 'application/json' },
      data: { command: cmd, token: token || this.data.token },
      success: (res) => {
        const d = (res && res.data) || {};
        const msg = d.message || d.err || '완료';
        this.setData({ loading: false, result: msg });
      },
      fail: () => {
        this.setData({ loading: false, result: '⚠️ 연결 실패 — 토큰·네트워크 확인' });
      }
    });
  }
}
</script>

<page>
  <view class="wrap">
    <text class="hd">🦌 RUDOLPH · LIVE</text>

    <view ink:if="{{ !ready }}" class="setup">
      <text class="dim">산타클로드 토큰을 넣고 연결해.</text>
      <input class="tin" placeholder="sc_… 토큰" bindinput="onTokenInput" />
      <button class="tbtn" bindtap="saveToken">연결</button>
    </view>

    <view ink:else>
      <text class="cmd">{{ cmd || '대기 중' }}</text>
      <view ink:if="{{ loading }}">
        <text class="dim">⋯ 루돌프 작업 중_</text>
      </view>
      <view ink:else>
        <text class="ok">{{ result }}</text>
      </view>
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
.setup { display: flex; flex-direction: column; }
.tin {
  color: #33ff66;
  background: #0a140d;
  border: 1px solid #1c5;
  border-radius: 8px;
  padding: 12px;
  font-size: 18px;
  margin: 12px 0;
}
.tbtn {
  color: #000;
  background: #33ff66;
  border-radius: 8px;
  padding: 12px;
  font-size: 18px;
  font-weight: bold;
  text-align: center;
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
