using System.Globalization;
using Robust.Shared.ContentPack;
using Robust.Shared.Utility;

namespace Content.Client.Guidebook;

/// <summary>
/// Resolves culture-specific Guidebook documents while keeping prototype paths culture-neutral.
/// </summary>
public static class GuidebookDocumentResolver
{
    private const string ServerInfoRoot = "/ServerInfo/";

    /// <summary>
    /// Returns a culture mirror under <c>/ServerInfo/&lt;culture&gt;/</c> when it exists,
    /// otherwise returns the unchanged base document path.
    /// </summary>
    public static ResPath Resolve(
        IResourceManager resourceManager,
        ResPath basePath,
        CultureInfo? culture)
    {
        if (culture == null || string.IsNullOrEmpty(culture.Name) || !basePath.IsRooted)
            return basePath;

        var basePathString = basePath.ToString();
        if (!basePathString.StartsWith(ServerInfoRoot, StringComparison.Ordinal))
            return basePath;

        var localizedPath = new ResPath(
            $"{ServerInfoRoot}{culture.Name}/{basePathString[ServerInfoRoot.Length..]}");

        return resourceManager.ContentFileExists(localizedPath)
            ? localizedPath
            : basePath;
    }
}
