import os
import yt_dlp

def baixar_musica_youtube(url, output_path="Musicas"):
    if not os.path.exists(output_path):
        os.makedirs(output_path)

    ydl_opts = {
        'format': 'bestaudio/best', 
        'outtmpl': os.path.join(output_path, '%(title)s.%(ext)s'),
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'mp3',  
            'preferredquality': '192',  
        }],
        'quiet': False,
    }

    try:

        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            ydl.download([url])
        
    except Exception as e:
        print("\nOcorreu um erro durante o processo:")
        print(e)


if __name__ == "__main__":
    youtube_url = input("Cole a URL do vídeo do YouTube aqui: ")
    
    if youtube_url:
        baixar_musica_youtube(youtube_url)
    else:
        print("Nenhuma URL fornecida. Encerrando o programa.")