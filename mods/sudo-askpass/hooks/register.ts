import type { Register } from 'claude-code'

const SUDO = /(^|[\s;&|(`])sudo(\s|$)/

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    const helper = `${$.plugin.root}/bin/askpass`
    // An installed copy may lose the executable bit.
    await $.process.run(['chmod', '+x', helper])
    const set = await $.env.set('SUDO_ASKPASS', helper)
    if (set.deny !== undefined) $.ui.log(`sudo-askpass: could not set SUDO_ASKPASS: ${set.deny}`)
    return next(e)
  })

  on('tool.call', { tool: 'Bash' }, async ($, e, next) => {
    if (!SUDO.test(e.command)) return next(e)
    $.ui.status('sudo: enter your password in the dialog if asked')
    try {
      return await next(e)
    } finally {
      $.ui.status(undefined)
    }
  }).catch(($, e, next) => next(e))
}
