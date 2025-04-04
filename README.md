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

Kurulum bittikten sonra :

![image](https://github.com/user-attachments/assets/c9070880-34bb-4073-af24-cd4bcad7c63b)
```
screen -r gensyn
```
ile screen'e girip "Y" yazıp enter yapın.

![image](https://github.com/user-attachments/assets/09d6e8c1-07a1-4871-a784-ab3387b0be6b)

![image](https://github.com/user-attachments/assets/9f35814e-6280-4289-9382-5b2472c05c72)

Daha sonra önce "1" yazan linki kopyalayıp tarayıcıya yapıştırıp ngrok sitesine kayıt olun daha sonra "2" yazan linki kopyalayıp tarayıcıya yapıştırın.

Size verdiği "Authtoken"i kopyalayın.

![image](https://github.com/user-attachments/assets/f3a90fcb-ef0e-414d-8ded-7ed7bcc21c15)

Buraya yapıştırıp enterlayın.

![image](https://github.com/user-attachments/assets/46d2eefd-71d0-4612-8140-a510c65bbc38)

Daha sonra size verdiği bu linki kopyalayıp tekrar tarayıcıya yapıştırın.

![image](https://github.com/user-attachments/assets/f8f1bdf2-3a70-446d-a781-cc20e30033a8)

"Visit Site"ye tıklayın.

![image](https://github.com/user-attachments/assets/09703f52-e781-41bb-8c46-ebf2f6e88ebe)

