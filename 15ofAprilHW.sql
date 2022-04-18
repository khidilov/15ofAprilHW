create table Artists
(
	ID int primary key identity,
	Name nvarchar(50),
	Listeners int
)

create table Albums
(
	ID int primary key identity,
	Name nvarchar(50),
	ArtistID int references Artists(ID)
	MusicQuantity int
)

create table Musics
(
	ID int primary key identity,
	Name nvarchar (50),
	Duration int,
	AlbumID int references Albums(ID)
	isDeleted nvarchar(20)
)




-- Query 1 Musics-in name-ni, totalSecond-nu, artist nama-ni, album name-ni göstərən bir view yazırsız.

create view ShowLibrary
as
select Artists.Name 'Artist Name', Albums.Name 'Album Name', Musics.Name 'Music Name', Musics.Duration 'Duration' from Artists
join Albums on Artists.ID = Albums.ArtistID
join Musics on Albums.ArtistID = Musics.AlbumID

select * from ShowLibrary where Upper([Music Name]) = Upper('Say It RiGht')


-- Query additional

alter table Albums add MusicQuantity int

create trigger UploadMusic
on Musics
after insert
as
begin
	Update Albums set MusicQuantity = MusicQuantity +1
	where ID = (select AlbumID from inserted Musics)
end

create trigger DeleteMusic
on Musics
after delete
as
begin
	Update Albums set MusicQuantity = MusicQuantity -1
	where ID = (select AlbumID from inserted Musics)
end




-- Query 2 Albumun adını və həmin albumda neçə dənə mahnı var onu göstərən bir view yazırsız.

create view ShowAlbumDetail
as
select Albums.Name, Albums.MusicQuantity from Albums

select * from ShowAlbumDetail where Name = ('Loose')

-- Query 3 ListenerCount-u parametr olaraq göndərilən listenerCount-dan böyük olan və Album adında parametr olaraq göndərilən search dəyəri olan bütün mahnıların adını, listenerCount-nu və Album adını göstərən bir procedure yazın.

alter procedure SongSearcher @ListenerCount int, @Checksimbol nvarchar(20)
as
select Musics.Name, Artists.Listeners, Albums.Name from Musics 
join Albums on Musics.AlbumID = Albums.ID
join Artists on Albums.ArtistID = Artists.ID
where (Listeners > @ListenerCount) and (Albums.Name like '%'+@Checksimbol+'%')

exec SongSearcher 100, 'L'

-- Query 4 Musicdə IsDeleted sütunu olsun. Əgər music-ə delete querysi yazılsa. Həmin sətr silinməsin, əvəzinə IsDeleted sütunu true olsub

alter table Musics add isDeletedPRIME nvarchar(20) default 'false'
alter procedure DeleteMusicPROC @DeleteRequest nvarchar(100)
as
update Musics set isDeletedPrime = 'true'
where Musics.Name = @DeleteRequest

exec DeleteMusicPROC 'Таблетки'

alter table Musics drop column isDeleted



exec DeleteMusicPROC 'Promiscuous'