#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk AS build
WORKDIR /src
COPY ["AspK8s/AspK8s.csproj", "AspK8s/"]
RUN dotnet restore "AspK8s/AspK8s.csproj"
COPY . .
WORKDIR "/src/AspK8s"
RUN dotnet build "AspK8s.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AspK8s.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AspK8s.dll"]