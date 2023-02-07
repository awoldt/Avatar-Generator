FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
ENV ASPNETCORE_URLS=http://*:8080

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["AvatarImageGenerator.csproj", "."]
RUN dotnet restore "./AvatarImageGenerator.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "AvatarImageGenerator.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AvatarImageGenerator.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AvatarImageGenerator.dll"]