import re
import string
from typing import Iterable, List, Optional, Tuple

import matplotlib.pyplot as plt
import pandas as pd
from matplotlib.figure import Figure
from matplotlib.pyplot import Axes
from urlextract import URLExtract

url_extractor = URLExtract()


def remove_duplicate_ngrams(text: str, max_n: int = 3) -> str:
    """
    Remove consecutive duplicate n-grams from text.

    Automatically normalizes hashtags (converts "# word" to "#word") before
    deduplication. Treats words with and without # as identical for comparison.

    Parameters
    ----------
    text : str
        Text to deduplicate (may contain # symbols).
    max_n : int, default=3
        Maximum n-gram size to check (checks unigrams, bigrams, up to max_n).

    Returns
    -------
    str
        Text with consecutive duplicate n-grams removed.

    Examples
    --------
    >>> remove_duplicate_ngrams("metoo metoo metoo")
    'metoo'

    >>> remove_duplicate_ngrams("metoo #metoo")
    'metoo'

    >>> remove_duplicate_ngrams("metoo # metoo")
    'metoo'

    >>> remove_duplicate_ngrams("i support metoo #metoo movement")
    'i support metoo movement'

    >>> remove_duplicate_ngrams("timesup metoo # timesup # metoo")
    'timesup metoo'

    >>> remove_duplicate_ngrams("#string string # string")
    '#string'

    >>> remove_duplicate_ngrams("#STRING string # string")
    '#STRING'
    """
    # 'normalise' the hashtags
    # eg: # string to #string (e.g., # metoo --> #metoo)
    text = re.sub(r"#\s+(\w+)", r"#\1", text)

    # tokenize
    tokens = text.split()

    if len(tokens) <= 1:
        return text

    # Create normalized version for comparison (remove # symbols and lowercase and punct)
    normalized = []
    for t in tokens:
        # Remove # and lowercase
        clean = t.replace("#", "").lower()
        # Strip trailing punctuation (but not internal like "can't")
        clean = clean.rstrip(string.punctuation)
        normalized.append(clean)

    # Iteratively remove duplicates, working from larger n-grams to smaller
    for n in range(max_n, 0, -1):
        new_tokens = []
        new_normalized = []

        i = 0
        while i < len(normalized):
            # Not enough tokens left for this n-gram size
            if i + n > len(normalized):
                new_tokens.append(tokens[i])
                new_normalized.append(normalized[i])
                i += 1
                continue

            # Get current n-gram (normalized)
            current_ngram = tuple(normalized[i : i + n])

            # Look ahead and skip all consecutive duplicates of this n-gram
            j = i + n
            while j + n <= len(normalized):
                next_ngram = tuple(normalized[j : j + n])
                if current_ngram == next_ngram:
                    j += n  # Skip the duplicate
                else:
                    break

            # Add only the first occurrence
            new_tokens.extend(tokens[i : i + n])
            new_normalized.extend(normalized[i : i + n])

            # Move index to position after all duplicates
            i = j

        # Update for next iteration
        tokens = new_tokens
        normalized = new_normalized

    return " ".join(tokens)


def preprocess_tweet(text: str) -> str:
    """
    Preprocess tweet text for BERTopic topic modeling.
    Removes common Twitter artifacts and noise while preserving substantive
    content for embedding-based topic modeling. Applies minimal preprocessing
    to maintain semantic context for transformer models.

    Parameters
    ----------
    text : str
        Raw tweet text to preprocess.

    Returns
    -------
    str
        Cleaned tweet text with URLs, mentions, and artifacts removed.
        Returns empty string if input is NaN/None.

    Examples
    --------
    >>> preprocess_tweet("RT @user: Check this out!!! https://example.com #MeToo")
    'check this out! metoo'
    >>> preprocess_tweet(None)
    ''

    Notes
    -----
    Preprocessing steps applied:
    - Convert to lowercase
    - Remove URLs using URLExtract (catches all URL formats)
    - Remove @mentions
    - Remove RT (retweet) markers
    - Remove # symbols (keep hashtag text)
    - Normalize repeated punctuation (!!! -> !)
    - Remove excessive whitespace
    """
    if pd.isna(text):
        return ""

    # Remove URLs using URLExtract (more comprehensive than regex)
    urls = url_extractor.find_urls(text)
    for url in urls:
        text = text.replace(url, "")

    # Remove @mentions
    # text = re.sub(r'@\w+', '', text)

    # Remove RT artifacts
    text = re.sub(r"\brt\s+", "", text, flags=re.IGNORECASE)

    # Remove hashtag symbol but keep text
    # text = text.replace("#", "")

    # Remove excessive punctuation (repeated chars like '!!!' -> '!')
    text = re.sub(r"([!?.]){2,}", r"\1", text)

    text = remove_duplicate_ngrams(text, max_n=3)

    # Remove excessive whitespace
    text = re.sub(r"\s+", " ", text).strip()

    return text


def print_tweet_sample(
    df: pd.DataFrame,
    n: int = 20,
    date: Optional[str] = None,
    label: Optional[str] = None,
    random_state: int = 1,
) -> None:
    """
    Print a random sample of tweets, optionally filtered by date.

    Parameters
    ----------
    df : pd.DataFrame
        DataFrame containing tweet data with columns: date, favorites,
        retweets, hashtags, content.
    n : int, default 20
        Number of tweets to sample.
    date : str or None, default None
        Date string to filter by (uses startswith matching on 'date' column).
        If None, samples from entire dataset.
    label : str or None, default None
        Optional label for the sample header. If None and date is provided,
        uses the date as label.
    random_state : int, default 1
        Random seed for reproducible sampling.

    Returns
    -------
    None
        Prints formatted sample to stdout.

    Examples
    --------
    >>> print_tweet_sample(df, n=20, date='2018-01-21', label='Women\'s March')
    >>> print_tweet_sample(df, n=20)  # Random sample from entire dataset
    """
    # Filter by date if provided
    if date is not None:
        sample_df = df[df["date"].str.startswith(date)]
        header_label = label or date
    else:
        sample_df = df
        header_label = label or "RANDOM SAMPLE"

    # Sample tweets
    sample = sample_df.sample(n=n, random_state=random_state)

    # Print header
    print(
        f"\nRANDOM SAMPLE OF {n} TWEETS"
        + (f" FROM {header_label}" if date or label else "")
    )
    print(f"Total tweets" + (f" on {date}" if date else "") + f": {len(sample_df):,}")
    if date:
        print(f"Percentage of all tweets: {len(sample_df)/len(df)*100:.2f}%")
    print("=" * 80)

    # Print each tweet
    for i, (idx, row) in enumerate(sample.iterrows(), 1):
        print(f"\n[{i}] {'Time' if date else 'Date'}: {row['date']}")
        print(f"Engagement: {row['favorites']} favs, {row['retweets']} RTs")
        print(f"Hashtags: {', '.join(row['hashtags']) if row['hashtags'] else 'none'}")
        print(f"\nContent: {row['content']}")
        print("-" * 80)


def extract_hashtags(
    text: str | None,
    *,
    ignore_metoo: bool = False,
) -> List[str]:
    """
    Extract hashtags from tweet text.

    Parameters
    ----------
    text : str or None
        Tweet text to extract hashtags from. Can be None or NaN.
    ignore_metoo : bool, default False
        If True, drop the '#metoo' hashtag (including spaced form '# metoo').

    Returns
    -------
    list of str
        List of lowercase hashtags with '#' prefix. Returns empty list if
        text is None/NaN or contains no hashtags. Handles both spaced
        ("#metoo") and non-spaced ("# metoo") hashtag formats.

    Examples
    --------
    >>> extract_hashtags("This is about #MeToo and # TimesUp")
    ['#metoo', '#timesup']

    >>> extract_hashtags("This is about #MeToo and # TimesUp", ignore_metoo=True)
    ['#timesup']

    >>> extract_hashtags(None)
    []

    >>> extract_hashtags("No hashtags here")
    []
    """
    if pd.isna(text):
        return []
    # Find hashtags (handle spaces like "# metoo" and normal "#metoo")
    hashtags = re.findall(r"#\s*\w+", str(text))
    # Clean up spaces and lowercase
    tags = [re.sub(r"\s+", "", tag).lower() for tag in hashtags]

    if ignore_metoo:
        tags = [t for t in tags if t != "#metoo"]

    return tags


def init_mpl_fig(
    aspect_ratio: Tuple[float, float] = (12, 8), scale: float = 1.0
) -> Tuple[Figure, Axes]:
    """
    Create a matplotlib figure and axes with a scaled aspect ratio.

    Args:
        aspect_ratio (tuple of float): Desired width-to-height ratio (default is (12, 8)).
        scale (float): Scaling factor to apply to the aspect ratio (default is 0.8).

    Returns:
        tuple: A tuple (fig, ax) where fig is the Figure object and ax is the Axes.

    Example:
        >>> fig, ax = make_fig(aspect_ratio=(16, 9), scale=1.0)
        >>> ax.plot([0, 1], [0, 1])
        >>> plt.show()
    """
    figsize = tuple(k * scale for k in aspect_ratio)
    fig, ax = plt.subplots(figsize=figsize)
    return fig, ax


def save_mpl_fig(
    savepath: str, formats: Optional[Iterable[str]] = None, dpi: Optional[int] = None
) -> None:
    """Save matplotlib figures to ../output.

    Will handle saving in png and in pdf automatically using the same file stem.

    Parameters
    ----------
    savepath: str
        Name of file to save to. No extensions.
    formats: Array-like
        List containing formats to save in. (By default 'png' and 'pdf' are saved).
        Do a:
            plt.gcf().canvas.get_supported_filetypes()
        or:
            plt.gcf().canvas.get_supported_filetypes_grouped()
        To see the Matplotlib-supported file formats to save in.
        (Source: https://stackoverflow.com/a/15007393)
    dpi: int
        DPI for saving in png.

    Returns
    -------
    None
    """
    # Save pdf
    plt.savefig(f"{savepath}.pdf", dpi=None, bbox_inches="tight", pad_inches=0)

    # save png
    plt.savefig(f"{savepath}.png", dpi=dpi, bbox_inches="tight", pad_inches=0)

    # Save additional file formats, if specified
    if formats:
        for format in formats:
            plt.savefig(
                f"{savepath}.{format}",
                dpi=None,
                bbox_inches="tight",
                pad_inches=0,
            )
    return None


def categorize_domain(domain):
    """Categorize domain into type"""
    news = [
        "nytimes.com",
        "theguardian.com",
        "washingtonpost.com",
        "cnn.com",
        "vox.com",
        "huffingtonpost.com",
        "wsj.com",
        "nbcnews.com",
        "hollywoodreporter.com",
        "apple.news",
        "msn.com",
        "yahoo.com",
        "newyorker.com",
    ]
    social = ["instagram.com", "facebook.com", "youtube.com", "youtu.be"]
    shorteners = [
        "bit.ly",
        "ow.ly",
        "buff.ly",
        "goo.gl",
        "dlvr.it",
        "ift.tt",
        "paper.li",
        "fb.me",
        "nyti.ms",
        "wapo.st",
        "trib.al",
    ]

    if any(d in domain for d in news):
        return "News"
    elif any(d in domain for d in social):
        return "Social"
    elif any(d in domain for d in shorteners):
        return "Shortener"
    else:
        return "Other"
