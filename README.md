![ewoOeVzl_400x400](https://github.com/user-attachments/assets/823eb796-85ca-438d-b9f5-136afad96e7e)

# Gensyn Node Kurulumu

# [Kurulum Videosu](https://youtu.be/jZIDwKNVwrU) 

## Sunucu Gereksinimleri

RAM : Minimum 16GB

CPU : arm64 veya amd64

Ubuntu 22.04

GPU : RTX 3090, RTX 4090, A100, H100 (en az 24gb vram ekran kartı)

NOT : Ödül verecekleri kesin değil, açıklanmış net bir teşvik henüz yok ödül verme ihtimallerine karşı kurulum yapıyoruz.

# ÖNEMLİ ! 

Sadece RAM veya CPU ile olmuyor bir süre sonra çöküyor model eğitimi olacağı için ekran kartı şart.Fiyatlar biraz yüksek fakat eğer kendi pc'nizde 24vram ve üzeri ekran kartı varsa [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) ile windows'un altına ubuntu yükleyerek kendi pc'nizde de bu nodeyi çalıştırabilirsiniz.(wsl ile ubuntu nasıl kurulur diye araştırın yanlış birşey yaparsanız pc'niz çökebilir her ihtimale karşı önemli verilerinizi yedekleyin)

GPU kiralamak isterseniz : [Quickpod](https://quickpod.io/), [Hyperbolic](https://app.hyperbolic.xyz/) sitelerini veya başka bir yer kullanabilirsiniz.

GPU Haricinde şimdilik [HETZNER](https://www.hetzner.com/dedicated-rootserver/) üzerindeki "AX41" sunucusunda çökmeden çalışıyor isteyen ona kurmayı da deneyebilir.

![image](https://github.com/user-attachments/assets/7b46d5f5-2b2c-4556-96e4-96558eb3b4c4)



# Kurulum Adımları
 
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

Login'e tıklayın.

![image](https://github.com/user-attachments/assets/518f930e-19bc-478f-9ea8-42e743bd1c54)

Buraya mail adresinizi girin.(google ile bağlanmayın çalışmıyor)

![image](https://github.com/user-attachments/assets/0e5703c3-cc40-4fb1-b607-9d4fd73562c2)

Daha sonra mailinize gelen kodu buraya yapıştırarak onaylayın.

![image](https://github.com/user-attachments/assets/d8cd7edb-f8ab-454c-8765-1d33db480d73)

Testnet'e kayıt yaptık.

![image](https://github.com/user-attachments/assets/d0749333-e127-4a5a-92e8-348ed9b3debb)


Node ekranına dönün ve yüklemenin bitmesini bekleyin.

Çıkan soruya "N" yazıp enterlayın.

![image](https://github.com/user-attachments/assets/d5c8d93f-f616-4a6f-82f9-9362ef495cf7)

![image](https://github.com/user-attachments/assets/77ef7a51-b5b6-47ec-a9b6-85a447d0c6af)

Bu şekilde bir ekran aldıysanız tamamdır Node ID yazan kelimeleri bir yere kaydedin son olarak swarm.pem dosyasını yedekleyelim.

[Winscp](https://winscp.net/eng/download.php) uygulamasını açıyorum

![image](https://github.com/user-attachments/assets/779c1336-0256-4e76-96f8-ca21cceb3333)

Sunucu ip yazıyorum kullanıcı adı root ve sunucu şifremi yazıp oturum aç diyorum.

rl-swarm klasörüne çift tıklayıp giriyorum.

![image](https://github.com/user-attachments/assets/c41b4b7f-3d7a-4780-baf2-e20f43ef7f90)

swarm.pem dosyasını tutup bilgisayarımın masaüstüne atıyorum.

![image](https://github.com/user-attachments/assets/890a8174-d0e2-4350-93c9-bd0a74edcfbf)

işlemler bu kadar.

CC : [ZUNXBT](https://github.com/zunxbt/gensyn-testnet)
