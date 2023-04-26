# https://nanx.me/blog/post/rebranding-r-packages-with-hexagon-stickers
# https://github.com/GuangchuangYu/hexSticker
library(bayesplot)
library(ggpubr)
sysfonts::font_add_google("Raleway", "pf", regular.wt = 500)

hexSticker::sticker(
  mcmc_intervals(example_mcmc_draws(params = 5), regex_pars = "beta") + theme_void() + theme_transparent(),
  s_x = 1, s_y = 0.75, s_width = 1.3, s_height = 1,
  package = "rstanosl", p_size = 30, h_size = 1.2, p_family = "pf",
  p_color = "#D94A32", h_fill = "#7AD7D7", h_color = "#D94A32",
  dpi = 320, filename = "man/figures/logo.png"
)

magick::image_read("man/figures/logo.png")

rstudioapi::restartSession()
