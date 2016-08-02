select * from emd_document d where d.documentnumber='7844562001220'

select * from emd_transaction d where d.documentid='304996'

select * from emd_transaction t where t.useraction='FS' group by t.documentid
