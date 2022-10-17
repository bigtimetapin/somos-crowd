import {deriveAuthorityPda, getAuthorityPda} from "./pda/authority-pda";

export async function getCreatorCollections(program, creator) {
    // build array of collections
    return await Promise.all(
        Array.from(new Array(creator.numCollections), async (_, index) => {
                // fetch authority for each collection
                const authorityPda = await deriveAuthorityPda(program, creator.handle, index + 1);
                const authority = await getAuthorityPda(program, authorityPda);
                console.log(authority);
                return {
                    name: authority.name,
                    symbol: authority.symbol,
                    index: index + 1
                }
            }
        )
    )
}
