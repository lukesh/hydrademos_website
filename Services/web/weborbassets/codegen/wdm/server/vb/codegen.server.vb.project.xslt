<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="codegen.server.vb.project">
    <file name="{codegen:getProjectName()}.vbproj" overwrite="false" type="xml">
      <Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
        <PropertyGroup>
          <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
          <Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
          <ProductVersion>8.0.50727</ProductVersion>
          <SchemaVersion>2.0</SchemaVersion>
          <ProjectGuid>
            <xsl:value-of select="codegen:getGuid()"/>
          </ProjectGuid>
          <OutputType>Library</OutputType>
          <RootNamespace></RootNamespace>
          <AssemblyName>
            <xsl:value-of select="codegen:getProjectName()"/>
          </AssemblyName>
          <MyType>Windows</MyType>
        </PropertyGroup>
        <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
          <DebugSymbols>true</DebugSymbols>
          <DebugType>full</DebugType>
          <DefineDebug>true</DefineDebug>
          <DefineTrace>true</DefineTrace>
          <OutputPath>bin\Debug\</OutputPath>
          <DocumentationFile>
            <xsl:value-of select="codegen:getProjectName()"/>.xml
          </DocumentationFile>
          <NoWarn>42016,41999,42017,42018,42019,42032,42036,42020,42021,42022</NoWarn>
        </PropertyGroup>
        <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
          <DebugType>pdbonly</DebugType>
          <DefineDebug>false</DefineDebug>
          <DefineTrace>true</DefineTrace>
          <Optimize>true</Optimize>
          <OutputPath>bin\Release\</OutputPath>
          <DocumentationFile>
            <xsl:value-of select="codegen:getProjectName()"/>.xml
          </DocumentationFile>
          <NoWarn>42016,41999,42017,42018,42019,42032,42036,42020,42021,42022</NoWarn>
        </PropertyGroup>
        <ItemGroup>
          <Reference Include="System" />
          <Reference Include="System.Data" />
          <Reference Include="System.Xml" />
          <Reference Include="weborb, Version=3.1.0.0, Culture=neutral, processorArchitecture=MSIL">
            <SpecificVersion>False</SpecificVersion>
            <HintPath>
              <xsl:value-of select="codegen:getWebORBDllPath()"/>
            </HintPath>
          </Reference>
          <xsl:if test="codegen:IsDBServerUsed('mysql')">
            <Reference Include="MySql.Data">
              <SpecificVersion>False</SpecificVersion>
              <HintPath>
                <xsl:value-of select="codegen:getMySQLDllPath()"/>
              </HintPath>
            </Reference>
          </xsl:if>
        </ItemGroup>
        <ItemGroup>
          <Import Include="Microsoft.VisualBasic" />
          <Import Include="System" />
          <Import Include="System.Collections" />
          <Import Include="System.Collections.Generic" />
          <Import Include="System.Data" />
          <Import Include="System.Diagnostics" />
        </ItemGroup>
        <ItemGroup>
          <Compile Include="**\*.vb" />
        </ItemGroup>
        <ItemGroup>
          <None Include="App.Config" />
        </ItemGroup>
        <Import Project="$(MSBuildBinPath)\Microsoft.VisualBasic.targets" />
      </Project>
    </file>
  </xsl:template>
</xsl:stylesheet>