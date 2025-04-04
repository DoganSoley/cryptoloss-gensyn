![ewoOeVzl_400x400](https://github.com/user-attachments/assets/823eb796-85ca-438d-b9f5-136afad96e7e)

# Gensyn Node Kurulumu

# [Kurulum Videosu](https://www.youtube.com/@Cryptoloss) 

## Sunucu Gereksinimleri

Minimum 16GB RAM

CPU arm64 veya amd64

Ubuntu 22.04

GPU : RTX 3090, RTX 4090, A100, H100 (en az 24gb vram ekran kartı)

Sadece RAM veya CPU ile olmuyor bir süre sonra çöküyor model eğitimi olacağı için ekran kartı şart.Fiyatlar biraz yüksek fakat eğer kendi pc'nizde 24vram ve üzeri ekran kartı varsa [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) ile windows'un altına ubuntu yükleyerek kendi pc'nizde de bu nodeyi çalıştırabilirsiniz.(wsl ile ubuntu nasıl kurulur diye araştırın yanlış birşey yaparsanız pc'niz çökebilir her ihtimale karşı önemli verilerinizi yedekleyin)

GPU kiralamak isterseniz : [Quickpod](https://quickpod.io/), [Hyperbolic](https://app.hyperbolic.xyz/) sitelerini veya başka bir yer kullanabilirsiniz.

Sunucuya bağlandıktan sonra :

Tek kod kurulum :

```
wget https://raw.githubusercontent.com/DoganSoley/cryptoloss-gensyn/refs/heads/main/script.sh && chmod +x script.sh && ./script.sh
```
