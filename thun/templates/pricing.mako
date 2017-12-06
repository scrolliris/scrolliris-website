<%inherit file='./_layout.mako'/>

<div class="content">
  <div class="grid pricing">
    <div class="row">
      <div class="offset-3 column-10 offset-v-1 column-v-14 column-n-16">
        <div class="tab menu">
          <a class="active item">For Author</a>
          <a class="disabled item">For Reader</a>
        </div>
        <h3 class="header">${_('we.love.transparency.title')|n,trim,clean(tags=['svg', 'use'], attributes={'svg': util.allow_svg('0 0 8 8'), 'use': ['href', 'class']})}</h3>
        <p class="description" align="left">${_('we.love.transparency.description')}</p>
      </div>
    </div>

    <div class="row">
      <div class="offset-3 column-2 offset-v-1 column-v-4 column-n-16">
        <div class="attached pricing box">
          <div class="header">Essential</div>
          <div class="price"><span>$0</span></div>
        </div>
        <div class="attached secondary pricing footer">
          <p>100% Free</p>
        </div>
      </div>
      <div class="column-4 column-v-5 column-n-16">
        <div class="attached pricing box">
          <div class="header">Professional</div>
          <div class="price"><span class="disabled">$36</span>/mo</div>
        </div>
        <div class="attached secondary pricing footer">
          <p>Save 10% on annual plan - <del>$389</del></p>
        </div>
      </div>
      <div class="column-4 column-v-5 column-n-16">
        <div class="attached pricing box">
          <div class="header">Epical</div>
          <div class="price"><span class="disabled">$63</span>/mo</div>
        </div>
        <div class="attached secondary pricing footer">
          <p>Save 10% on annual plan - <del>$680</del></p>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="offset-3 column-10 offset-v-1 column-v-14 column-n-16">
        <p class="note"><span class="development">*</span> Many features below (incl. payment) are still under development ;)</p>
        <div class="table-container">
          <table class="table pricing-table">
            <thead>
              <tr>
                <th align="left">Feature</th>
                <th>Essential</th>
                <th>Professional</th>
                <th>Epical</th>
              </tr>
            </thead>
            <tbody>
              <tr class="sub-heading">
                <td colspan="4"><h6 class="header">HOSTED</h6></td>
              </tr>
              <tr>
                <td class="disabled"><p>Publications<span class="development">*</span></p><span class="small text">on scrolliris.com</span></td>
                <td class="disabled" align="center">unlimited</td>
                <td class="disabled" align="center">unlimited</td>
                <td align="center">unlimited</td>
              </tr>
              <tr class="disabled">
                <td><p>Built-in Readability Analysis Feedback<span class="development">*</span></p></td>
                <td class="sign" align="center">&#10003;</td>
                <td class="sign" align="center">&#10003;</td>
                <td class="sign" align="center">&#10003;</td>
              </tr>
              <tr class="disabled">
                <td><p>Text Linting & Writing Support Feature<span class="development">*</span></p></td>
                <td class="sign" align="center">&#10003;</td>
                <td class="sign" align="center">&#10003;</td>
                <td class="sign" align="center">&#10003;</td>
              </tr>
              <tr class="disabled">
                <td><p>Team Collaboration Feature<span class="development">*</span></p></td>
                <td class="sign" align="center">&#10003;</td>
                <td class="sign" align="center">&#10003;</td>
                <td class="sign" align="center">&#10003;</td>
              </tr>
              <tr class="disabled">
                <td><p>Git Access over HTTPS<span class="development">*</span></p></td>
                <td class="sign" align="center"></td>
                <td class="sign" align="center">&#10003;</td>
                <td class="sign" align="center">&#10003;</td>
              </tr>
              <tr class="disabled">
                <td><p>Custom Domain<span class="development">*</span></p></td>
                <td class="sign" align="center"></td>
                <td class="sign" align="center">&#10003;</td>
                <td class="sign" align="center">&#10003;</td>
              </tr>
              <tr class="disabled">
                <td><p>Revenue from Reader<span class="development">*</span></p></td>
                <td class="sign" align="center"></td>
                <td class="sign" align="center">&#10003;</td>
                <td class="sign" align="center">&#10003;</td>
              </tr>
              <tr class="sub-heading">
                <td colspan="4"><h6 class="header">INTEGRATED</h6></td>
              </tr>
              <tr>
                <td><p>Applications</p><span class="small text">document on the system you owned</span></td>
                <td align="center">&nbsp;</td>
                <td align="center"><p>unlimited</p><span class="small text">1 domain</span></td>
                <td align="center"><p>unlimited</p><span class="small text">3 domains</span></td>
              </tr>
              <tr>
                <td>Readability Analysis Integration</td>
                <td class="sign" align="center"></td>
                <td class="sign" align="center">&#10003;</td>
                <td class="sign" align="center">&#10003;</td>
              </tr>
              <tr class="disabled">
                <td><p>Email Report<span class="development">*</span></p></td>
                <td class="sign" align="center"></td>
                <td class="sign" align="center">&#10003;</td>
                <td class="sign" align="center">&#10003;</td>
              </tr>
              <tr class="sub-heading">
                <td colspan="4"><h6 class="header">DATA</h6></td>
              </tr>
              <tr>
                <td><p>Live Data Retention</p><span class="small text">on dashboard</span></td>
                <td align="center">2 weeks</td>
                <td align="center">1 month</td>
                <td align="center">3 months</td>
              </tr>
              <tr class="disabled">
                <td><p>Open Data Archive<span class="development">*</span></p></td>
                <td class="sign" align="center">∞</td>
                <td class="sign" align="center">∞</td>
                <td class="sign" align="center">∞</td>
              </tr>
              <tr>
                <td><p>Private Tracking Data</p><span class="small text">we don't make data private</span></td>
                <td class="sign" align="center">&#10060;</td>
                <td class="sign" align="center">&#10060;</td>
                <td class="sign" align="center">&#10060;</td>
              </tr>
              <tr class="sub-heading">
                <td colspan="4"><h6 class="header">SUPPORT</h6></td>
              </tr>
              <tr>
                <td><p>Help<span class="development">*</span></p></td>
                <td align="center"><p>online doc</p><span class="small text"><a href="/">help.scrolliris.com</a></span></td>
                <td class="disabled" align="center"><p>live chat</p><span class="small text">with Developer</span></td>
                <td class="disabled" align="center"><p>live chat</p><span class="small text">with Developer</span></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="column-16">
        <a class="primary button" href="https://scrolliris.com/signup">Signup</a>
        <p class="description"><del>You can cancel the subscription or downgrade plan, anytime</del><br>Currently, we are public beta.</p>
      </div>
    </div>
  </div>
</div>
